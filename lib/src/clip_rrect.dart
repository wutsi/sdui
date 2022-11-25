import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor [ClipRRect].
class SDUIClipRRect extends SDUIWidget {
  double? borderRadius;

  @override
  SDUIClipRRect fromJson(Map<String, dynamic>? json) {
    borderRadius = json?["borderRadius"];
    return this;
  }

  @override
  Widget toWidget(BuildContext context) => ClipRRect(
      borderRadius:
          borderRadius == null ? null : BorderRadius.circular(borderRadius!),
      child: child()?.toWidget(context));
}
