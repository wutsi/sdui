import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Text]
class SDUIText extends SDUIWidget {
  String? caption;
  String? overflow;
  String? color;
  bool? bold;
  bool? italic;
  double? size;
  String? alignment;
  String? decoration;
  int? maxLines;

  SDUIText(
      {this.caption,
      this.overflow,
      this.color,
      this.bold,
      this.italic,
      this.size,
      this.alignment,
      this.decoration});

  @override
  Widget toWidget(BuildContext context) => Text(
        caption ?? '',
        overflow: _toTextOverflow(),
        style: _toTextStyle(),
        textAlign: toTextAlign(alignment),
        maxLines: maxLines,
        key: id == null ? null : Key(id!),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    caption = json?['caption'];
    overflow = json?['overflow'];
    color = json?['color'];
    bold = json?['bold'];
    italic = json?['italic'];
    size = json?['size'];
    alignment = json?['alignment'];
    decoration = json?['decoration'];
    maxLines = json?['maxLines'];
    return super.fromJson(json);
  }

  TextOverflow? _toTextOverflow() {
    switch (overflow?.toLowerCase()) {
      case 'clip':
        return TextOverflow.clip;
      case 'ellipsis':
        return TextOverflow.ellipsis;
      case 'fade':
        return TextOverflow.fade;
      case 'visible':
        return TextOverflow.visible;
    }
    return null;
  }

  TextStyle? _toTextStyle() => TextStyle(
      color: toColor(color),
      fontSize: size,
      fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
      fontStyle: italic == true ? FontStyle.italic : FontStyle.normal,
      decoration: _toTextDecoration());

  TextDecoration? _toTextDecoration() {
    switch (decoration?.toLowerCase()) {
      case 'strikethrough':
        return TextDecoration.lineThrough;
      case 'overline':
        return TextDecoration.overline;
      case 'underline':
        return TextDecoration.underline;
    }
    return null;
  }
}
