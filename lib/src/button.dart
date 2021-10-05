import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a button
///
/// ### JSON Attributes
///  - *caption*: Caption of the button
///  - *padding*: Button padding.
///  - *type*: Type of button. The values are:
///     - `elevated` for [ElevatedButton] (default)
///     - `text` for [TextButton]
///     - `outlined` for [OutlinedButton]
class SDUIButton extends SDUIWidget {
  String? caption;
  String? type;
  double? padding;

  @override
  Widget toWidget(BuildContext context) => createWidget(
      caption: caption ?? 'Button',
      type: type,
      padding: padding,
      context: context,
      onPressed: () => action.execute(context, null));

  static Widget createWidget(
          {required String caption,
          String? type,
          double? padding,
          required BuildContext context,
          required VoidCallback? onPressed}) =>
      SizedBox(
          width: double.maxFinite,
          child: _createWidget(caption, type, padding, context, onPressed));

  static Widget _createWidget(String caption, String? type, double? padding,
      BuildContext context, VoidCallback? onPressed) {
    switch (type?.toLowerCase()) {
      case 'text':
        return TextButton(
          child: _createText(caption, padding),
          onPressed: onPressed,
        );

      case 'outlined':
        return OutlinedButton(
          child: _createText(caption, padding),
          onPressed: onPressed,
        );

      default:
        return ElevatedButton(
          child: _createText(caption, padding),
          onPressed: onPressed,
        );
    }
  }

  static Widget _createText(String caption, double? padding) =>
      Padding(padding: EdgeInsets.all(padding ?? 15), child: Text(caption));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    caption = json?["caption"];
    type = json?["type"];
    padding = json?["padding"];
    return this;
  }
}
