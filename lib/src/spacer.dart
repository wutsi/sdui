import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of an [Spacer]
///
/// ### JSON Attributes
/// - **flex**: The flex factor to use in determining how much space to take up. Default=1
class SDUISpacer extends SDUIWidget {
  int flex = 1;

  SDUISpacer({this.flex = 1});

  @override
  Widget toWidget(BuildContext context) => Spacer(flex: flex);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    flex = json?["flex"] ?? 1;
    return this;
  }
}
