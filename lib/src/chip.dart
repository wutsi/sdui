import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Chip]
class SDUIChip extends SDUIWidget {
  String? color;
  double? padding;
  double? elevation;
  String? shadowColor;

  @override
  Widget toWidget(BuildContext context) => Chip(
        elevation: elevation,
        backgroundColor: toColor(color),
        shadowColor: toColor(shadowColor),
        label: child()?.toWidget(context) ?? const Text(''),
        padding: padding == null ? null : EdgeInsets.all(padding!),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    color = json?["color"];
    padding = json?["padding"];
    elevation = json?["elevation"];
    shadowColor = json?["shadowColor"];

    return super.fromJson(json);
  }
}
