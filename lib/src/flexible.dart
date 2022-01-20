import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Flexible]
///
/// ### JSON Attributes
class SDUIFlexible extends SDUIWidget {
  /// see [Flexible.flex]
  int flex = 1;

  /// see [Flexible.fit]
  String fit = 'tight';

  @override
  Widget toWidget(context) => children.isEmpty
      ? Container()
      : Flexible(
          child: child()!.toWidget(context), flex: flex, fit: _toFlexFit());

  FlexFit _toFlexFit() {
    switch (fit.toLowerCase()) {
      case "loose":
        return FlexFit.loose;
      default:
        return FlexFit.tight;
    }
  }

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    flex = json?["flex"] ?? 1;
    fit = json?["fit"] ?? 'tight';
    return this;
  }
}
