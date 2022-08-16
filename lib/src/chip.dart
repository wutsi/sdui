import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Chip]
class SDUIChip extends SDUIWidget {
  String? color;
  String? backgroundColor;
  String? caption;
  double? padding;
  double? elevation;
  String? shadowColor;
  double? fontSize;

  @override
  Widget toWidget(BuildContext context) => Chip(
        key: id == null ? null : Key(id!),
        elevation: elevation,
        backgroundColor: toColor(backgroundColor) ?? Colors.red,
        shadowColor: toColor(shadowColor),
        label: caption != null
            ? Text(caption!,
                style: TextStyle(
                    color: toColor(color) ?? Colors.white, fontSize: fontSize))
            : const Text(''),
        padding: padding == null ? null : EdgeInsets.all(padding!),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    color = json?["color"];
    backgroundColor = json?["backgroundColor"];
    caption = json?["caption"];
    padding = json?["padding"];
    elevation = json?["elevation"];
    shadowColor = json?["shadowColor"];
    fontSize = json?["fontSize"];

    return super.fromJson(json);
  }
}
