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
      return Image.network(
        code!,
        width: size,
        height: size,
      );
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

  void attachPageController(PageController? controller) {
    action.pageController = controller;
    for (var i = 0; i < children.length; i++) {
      children[i].attachPageController(controller);
    }
  }
}
