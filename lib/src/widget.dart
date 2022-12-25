import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'action.dart';

/// Abstraction for describing a Flutter [Widget].
/// This descriptor has:
/// - an action that contains information about the widget behavior
/// - a list of children widget descriptors
abstract class SDUIWidget {
  String? id;
  SDUIAction action = SDUIAction();
  List<SDUIWidget> children = <SDUIWidget>[];

  bool hasChildren() => children.isNotEmpty;

  /// Return the first child
  SDUIWidget? child() => children.isEmpty ? null : children.first;

  /// Return the list of children [Widget]
  List<Widget> childrenWidgets(BuildContext context) =>
      children.map((e) => e.toWidget(context)).toList();

  /// Return the associated [Widget]
  Widget toWidget(BuildContext context);

  /// Load the attributes of the widget descriptor from
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    return this;
  }

  Widget? toIcon(String? code, {double? size, String? color}) {
    if (code?.startsWith("http://") == true ||
        code?.startsWith("https://") == true) {
      return CachedNetworkImage(
          imageUrl: code!,
          width: size,
          height: size,
          errorWidget: (context, url, error) => const Icon(Icons.error));
    } else {
      return code == null
          ? null
          : Icon(toIconData(code), size: size, color: toColor(color));
    }
  }

  Axis toAxis(String? direction) => direction?.toLowerCase() == "horizontal"
      ? Axis.horizontal
      : Axis.vertical;

  Color? toColor(String? hexColor) {
    if (hexColor == null) {
      return null;
    }
    final hexCode = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  TextAlign? toTextAlign(String? alignment) {
    switch (alignment?.toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      case 'end':
        return TextAlign.end;
      case 'start':
        return TextAlign.start;
    }
    return null;
  }

  IconData? toIconData(String? code) {
    if (code == null) {
      return null;
    }

    final hexCode = code.replaceFirst('0x', '');
    return IconData(int.parse(hexCode, radix: 16), fontFamily: 'MaterialIcons');
  }

  MainAxisSize toMainAxisSize(String? value) {
    switch (value?.toLowerCase()) {
      case "min":
        return MainAxisSize.min;
    }
    return MainAxisSize.max;
  }

  CrossAxisAlignment toCrossAxisAlignment(String? value) {
    switch (value?.toLowerCase()) {
      case "end":
        return CrossAxisAlignment.end;
      case "start":
        return CrossAxisAlignment.start;
      case "baseline":
        return CrossAxisAlignment.baseline;
      case "stretch":
        return CrossAxisAlignment.stretch;
    }
    return CrossAxisAlignment.center;
  }

  MainAxisAlignment toMainAxisAlignment(String? value) {
    switch (value?.toLowerCase()) {
      case "end":
        return MainAxisAlignment.end;
      case "center":
        return MainAxisAlignment.center;
      case "spacearound":
        return MainAxisAlignment.spaceAround;
      case "spaceevenly":
        return MainAxisAlignment.spaceEvenly;
      case "spacebetween":
        return MainAxisAlignment.spaceBetween;
    }
    return MainAxisAlignment.start;
  }

  BoxFit? toBoxFit(String? fit) {
    switch (fit?.toLowerCase()) {
      case "none":
        return BoxFit.none;
      case "contain":
        return BoxFit.contain;
      case "cover":
        return BoxFit.cover;
      case "fill":
        return BoxFit.fill;
      case "fitHeight":
        return BoxFit.fitHeight;
      case "fitWidth":
        return BoxFit.fitWidth;
      case "scaleDown":
        return BoxFit.scaleDown;
    }
    return null;
  }

  Alignment? toAlignment(String? alignment) {
    switch (alignment) {
      case 'bottom-center':
      case 'bottomcenter':
        return Alignment.bottomCenter;

      case 'bottom-left':
      case 'bottomleft':
        return Alignment.bottomLeft;

      case 'bottom-right':
      case 'bottomright':
        return Alignment.bottomRight;

      case 'center':
        return Alignment.center;

      case 'center-left':
      case 'centerleft':
        return Alignment.centerLeft;

      case 'center-right':
      case 'centerright':
        return Alignment.centerRight;

      case 'top-center':
      case 'topcenter':
        return Alignment.topCenter;

      case 'top-left':
      case 'topleft':
        return Alignment.topLeft;

      case 'top-right':
      case 'topright':
        return Alignment.topRight;
    }
    return null;
  }

  Clip? toClip(String? clip) {
    switch (clip?.toLowerCase()) {
      case "none":
        return Clip.none;
      case "antialias":
        return Clip.antiAlias;
      case "antialiaswithsavelayer":
        return Clip.antiAliasWithSaveLayer;
      case "hardedge":
        return Clip.hardEdge;
    }
    return null;
  }

  void attachPageController(PageController? controller) {
    action.pageController = controller;
    for (var i = 0; i < children.length; i++) {
      children[i].attachPageController(controller);
    }
  }

  void attachScreen(SDUIWidget screen) {
    action.screen = screen;
    for (var element in children) {
      element.attachScreen(screen);
    }
  }
}
