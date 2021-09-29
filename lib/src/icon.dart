import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

class SDUIIcon extends SDUIWidget {
  String? code;

  SDUIIcon({this.code});

  @override
  Widget toWidget(BuildContext context) => Icon(toIconData(code));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? attributes) {
    code = attributes?["code"];
    return this;
  }
}
