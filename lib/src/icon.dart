import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of an [Icon]
class SDUIIcon extends SDUIWidget {
  /// Icon code point in Hexadecimal
  String? codePoint;

  SDUIIcon({this.codePoint});

  @override
  Widget toWidget(BuildContext context) => Icon(toIconData(codePoint));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    codePoint = json?["code"];
    return this;
  }
}
