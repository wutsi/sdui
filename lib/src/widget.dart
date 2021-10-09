import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'action.dart';

/// Abstraction for describing a Flutter [Widget].
/// This descriptor has:
/// - an action that contains information about the widget behavior
/// - a list of children widget descriptors
abstract class SDUIWidget {
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
    return this;
  }

  Widget? toIcon(String? code) => Icon(toIconData(code));

  Color? toColor(String? hexColor) {
    if (hexColor == null) {
      return null;
    }
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  IconData? toIconData(String? hexCode) {
    if (hexCode == null) {
      return null;
    }

    return IconData(int.parse(hexCode, radix: 16), fontFamily: 'MaterialIcons');
  }

  void attachPageController(PageController? controller) {
    action.pageController = controller;
    for (var i = 0; i < children.length; i++) {
      children[i].attachPageController(controller);
    }
  }
}
