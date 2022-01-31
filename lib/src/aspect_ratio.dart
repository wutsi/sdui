import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [AspectRatio]
class SDUIAspectRatio extends SDUIWidget {
  double? aspectRatio;

  @override
  Widget toWidget(BuildContext context) => AspectRatio(
        aspectRatio: aspectRatio ?? 1,
        child: child()?.toWidget(context),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    aspectRatio = json?["aspectRatio"];
    return super.fromJson(json);
  }
}
