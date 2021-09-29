import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

class SDUIFlexible extends SDUIComposite {
  int? flex;
  String? fit;

  SDUIFlexible({this.flex = 1, this.fit});

  @override
  Widget toWidget(context) => Flexible(
      child: child().toWidget(context), flex: flex ?? 1, fit: _toFlexFit());

  FlexFit _toFlexFit() {
    switch (fit?.toLowerCase()) {
      case "loose":
        return FlexFit.loose;
      default:
        return FlexFit.tight;
    }
  }

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    fit = json?["fit"];
    flex = json?["flex"];
    return this;
  }
}
