import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [SingleChildScrollView]
class SDUISingleChildScrollView extends SDUIWidget {
  String? scrollDirection;
  bool? primary;
  bool? reverse;
  double? padding;

  @override
  Widget toWidget(BuildContext context) => SingleChildScrollView(
      primary: primary,
      scrollDirection: toAxis(scrollDirection),
      reverse: reverse ?? false,
      padding: padding == null ? null : EdgeInsets.all(padding!),
      child: child()?.toWidget(context));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    scrollDirection = json?["scrollDirection"];
    primary = json?["primary"];
    reverse = json?["reverse"];
    padding = json?["padding"];
    return super.fromJson(json);
  }
}
