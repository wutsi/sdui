import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of an [IconButton]
///
/// ### JSON Attributes
/// - **icon**: Icon code point. See [IconData]
/// - **tooltip**: Tooltip
/// - **size**: Icon size
/// - **color**: Icon color in hexadecimal
/// - **action**: [SDUIAction] to execute when the button is clicked
class SDUIIconButton extends SDUIWidget {
  String? icon;
  String? tooltip;
  double? size;
  String? color;

  @override
  Widget toWidget(BuildContext context) => IconButton(
        iconSize: size ?? 24.0,
        icon: icon == null ? const Icon(Icons.warning) : toIcon(icon)!,
        color: toColor(color),
        tooltip: tooltip,
        onPressed: () => action
            .execute(context, null)
            .then((value) => action.handleResult(context, value)),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    icon = json?["icon"];
    tooltip = json?["tooltip"];
    size = json?["size"];
    color = json?["color"];
    return this;
  }
}
