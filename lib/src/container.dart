import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'widget.dart';

/// Descriptor of a [Container].
class SDUIContainer extends SDUIWidget {
  String? alignment;
  double? padding;
  double? margin;
  String? background;
  double? border;
  double? borderRadius;
  String? borderColor;

  SDUIContainer(
      {this.alignment,
      this.padding,
      this.margin,
      this.background,
      this.border,
      this.borderRadius});

  @override
  Widget toWidget(BuildContext context) => Container(
        child: child().toWidget(context),
        margin: margin == null ? null : EdgeInsets.all(margin!),
        padding: padding == null ? null : EdgeInsets.all(padding!),
        alignment: _toAlignment(),
        decoration: _toBoxDecoration(context),
      );

  Alignment? _toAlignment() {
    switch (alignment) {
      case 'bottom-center':
        return Alignment.bottomCenter;
      case 'bottom-left':
        return Alignment.bottomLeft;
      case 'bottom-right':
        return Alignment.bottomRight;
      case 'center':
        return Alignment.center;
      case 'center-left':
        return Alignment.centerLeft;
      case 'center-right':
        return Alignment.centerRight;
      case 'top-center':
        return Alignment.topCenter;
      case 'top-left':
        return Alignment.topLeft;
      case 'top-right':
        return Alignment.topRight;
    }
    return null;
  }

  BoxDecoration _toBoxDecoration(BuildContext context) => BoxDecoration(
        color: toColor(background),
        border: border == null
            ? null
            : Border.all(
                color: toColor(borderColor) ?? Theme.of(context).primaryColor,
                width: border!,
              ),
        borderRadius:
            borderRadius == null ? null : BorderRadius.circular(borderRadius!),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? attributes) {
    alignment = attributes?["alignment"];
    padding = attributes?["padding"];
    margin = attributes?["margin"];
    border = attributes?["border"];
    borderRadius = attributes?["borderRadius"];
    borderColor = attributes?["borderColor"];
    background = attributes?["background"];
    return this;
  }
}
