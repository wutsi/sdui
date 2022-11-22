import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor [ClipRRect].
class SDUIClipRRect extends SDUIWidget {
  double? borderRadius;

  SDUIClipRRect fromJson(Map<String, dynamic>? attributes) {
    borderRadius = attributes?["borderRadius"];
    return this;
  }

  @override
  Widget toWidget(BuildContext context) => ClipRRect(
      borderRadius:
          borderRadius == null ? null : BorderRadius.circular(borderRadius!),
      child: child()?.toWidget(context));
}
