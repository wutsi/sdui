import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

/// Descriptor of an [Divider].
///
/// ### JSON Attributes
/// - **height**: Divider height
/// - **color**: Divider color
class SDUIDivider extends SDUIWidget {
  double? height;
  String? color;

  @override
  Widget toWidget(BuildContext context) =>
      Divider(height: height, color: toColor(color));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    color = json?["color"];
    height = json?["height"];
    return this;
  }
}
