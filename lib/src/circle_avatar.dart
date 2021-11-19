import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

/// Descriptor of an [CircleAvatar].
///
/// ### JSON Attributes
/// - **radius**: Radius
class SDUICircleAvatar extends SDUIWidget {
  double? radius;

  @override
  Widget toWidget(BuildContext context) => CircleAvatar(
        radius: radius,
        child: child()?.toWidget(context),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    radius = json?["radius"];
    return super.fromJson(json);
  }
}
