import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [GridView]
class SDUIGridView extends SDUIWidget {
  int? crossAxisCount;
  double? mainAxisSpacing;
  double? crossAxisSpacing;
  double? padding;
  bool? primary;

  @override
  Widget toWidget(BuildContext context) => GridView.count(
      primary: primary,
      padding: padding == null ? null : EdgeInsets.all(padding!),
      crossAxisSpacing: crossAxisSpacing ?? 10,
      mainAxisSpacing: mainAxisSpacing ?? 10,
      crossAxisCount: crossAxisCount ?? 2,
      children: childrenWidgets(context));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    crossAxisCount = json?["crossAxisCount"];
    mainAxisSpacing = json?["mainAxisSpacing"];
    crossAxisSpacing = json?["crossAxisSpacing"];
    padding = json?["padding"];
    primary = json?["primary"];
    return super.fromJson(json);
  }
}
