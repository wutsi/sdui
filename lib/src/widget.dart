import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'action.dart';

abstract class SDUIWidget {
  SDUIAction action = SDUIAction();

  Widget toWidget(BuildContext context);

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
}

abstract class SDUIComposite extends SDUIWidget {
  List<SDUIWidget> children = <SDUIWidget>[];

  SDUIWidget child() => children.first;

  List<Widget> childrenWidgets(BuildContext context) =>
      children.map((e) => e.toWidget(context)).toList();
}
