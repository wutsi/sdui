import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Chip]
class SDUIChip extends SDUIWidget {
  String? color;
  double? padding;

  @override
  Widget toWidget(BuildContext context) => Chip(
        backgroundColor: toColor(color),
        label: child()?.toWidget(context) ?? const Text(''),
        padding: padding == null ? null : EdgeInsets.all(padding!),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    color = json?["color"];
    padding = json?["padding"];

    return super.fromJson(json);
  }
}
