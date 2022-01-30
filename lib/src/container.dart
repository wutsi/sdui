import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Container].
///
/// ### JSON Attributes
/// - **alignment**: Alignment of the child in the container
/// - **padding**: Padding of the container
/// - **margin**: Margin of the container
/// - **background**: Background color code
/// - **border**: Border size
/// - **borderRadius**: Radius of the border
/// - **borderColor**: Color of the border
/// - **backgroundImageUrl**: Background Image
/// - **width**: Width
/// - **height**: Height
/// - **action**: Container action on tap
class SDUIContainer extends SDUIWidget {
  String? alignment;
  double? padding;
  double? margin;
  String? background;
  double? border;
  double? borderRadius;
  String? borderColor;
  String? backgroundImageUrl;
  double? width;
  double? height;

  @override
  Widget toWidget(BuildContext context) => action.type == null
      ? _createContainer(context)
      : GestureDetector(
          onTap: () => _onTap(context), child: _createContainer(context));

  Container _createContainer(BuildContext context) => Container(
        child: child()?.toWidget(context),
        margin: margin == null ? null : EdgeInsets.all(margin!),
        padding: padding == null ? null : EdgeInsets.all(padding!),
        alignment: _toAlignment(),
        decoration: _toBoxDecoration(context),
        width: width,
        height: height,
      );

  void _onTap(BuildContext context) {
    action
        .execute(context, null)
        .then((value) => action.handleResult(context, value));
  }

  Alignment? _toAlignment() {
    switch (alignment) {
      case 'bottom-center':
      case 'bottomcenter':
        return Alignment.bottomCenter;

      case 'bottom-left':
      case 'bottomleft':
        return Alignment.bottomLeft;

      case 'bottom-right':
      case 'bottomright':
        return Alignment.bottomRight;

      case 'center':
        return Alignment.center;

      case 'center-left':
      case 'centerleft':
        return Alignment.centerLeft;

      case 'center-right':
      case 'centerright':
        return Alignment.centerRight;

      case 'top-center':
      case 'topcenter':
        return Alignment.topCenter;

      case 'top-left':
      case 'topleft':
        return Alignment.topLeft;

      case 'top-right':
      case 'topright':
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
      image: backgroundImageUrl == null
          ? null
          : DecorationImage(
              image: NetworkImage(backgroundImageUrl!), fit: BoxFit.fill));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    alignment = json?["alignment"];
    padding = json?["padding"];
    margin = json?["margin"];
    border = json?["border"];
    borderRadius = json?["borderRadius"];
    borderColor = json?["borderColor"];
    background = json?["background"];
    backgroundImageUrl = json?["backgroundImageUrl"];
    width = json?["width"];
    height = json?["height"];
    return this;
  }
}
