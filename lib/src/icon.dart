import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of an [Icon] or [ImageIcon]
///
/// ### JSON Attributes
/// - **code**: Icon code point (See [IconData]) or icon URL.
/// - **size**: Icon size
/// - **color**: color code in hexadecimal
class SDUIIcon extends SDUIWidget {
  String? code;
  double? size;
  String? color;

  SDUIIcon({this.code});

  @override
  Widget toWidget(BuildContext context) =>
      toIcon(code, size: size, color: color) ?? const Icon(Icons.error);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    code = json?["code"];
    size = json?["size"];
    color = json?["color"];
    return this;
  }
}
