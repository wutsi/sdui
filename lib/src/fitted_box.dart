import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [FittedBox].
///
class SDUIFittedBox extends SDUIWidget {
  String? fit;
  String? alignment;
  String? clip;

  @override
  Widget toWidget(BuildContext context) => FittedBox(
        fit: toBoxFit(fit) ?? BoxFit.none,
        alignment: toAlignment(alignment) ?? Alignment.center,
        clipBehavior: toClip(clip) ?? Clip.none,
        child: child()?.toWidget(context),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    alignment = json?["alignment"];
    fit = json?["fit"];
    clip = json?["clip"];
    return this;
  }
}
