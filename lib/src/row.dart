import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Row]
class SDUIRow extends SDUIWidget {
  String? mainAxisAlignment;
  String? crossAxisAlignment;
  String? mainAxisSize;

  @override
  Widget toWidget(BuildContext context) => Row(
        mainAxisSize: toMainAxisSize(mainAxisSize),
        crossAxisAlignment: toCrossAxisAlignment(crossAxisAlignment),
        mainAxisAlignment: toMainAxisAlignment(mainAxisAlignment),
        children: childrenWidgets(context),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    mainAxisAlignment = json?["mainAxisAlignment"];
    crossAxisAlignment = json?["crossAxisAlignment"];
    mainAxisSize = json?["mainAxisSize"];
    return super.fromJson(json);
  }
}
