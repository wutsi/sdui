import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Wrap]
class SDUIWrap extends SDUIWidget {
  double? spacing;
  double? runSpacing;
  String? direction;

  @override
  Widget toWidget(BuildContext context) => Wrap(
      direction: toAxis(direction),
      runSpacing: runSpacing ?? 0.0,
      spacing: spacing ?? 0.0,
      children: childrenWidgets(context));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    runSpacing = json?["runSpacing"];
    spacing = json?["spacing"];
    direction = json?["direction"];
    return super.fromJson(json);
  }
}
