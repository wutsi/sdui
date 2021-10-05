import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a button
///
/// ### JSON Attributes
///  - *caption*: Caption of the button
///  - *type*: Type of button. The values are:
///     - `elevated` for [ElevatedButton] (default)
///     - `text` for [TextButton]
///     - `outlined` for [OutlinedButton]
class SDUIButton extends SDUIWidget {
  String caption = '<NO-CAPTION>';
  String? type;

  @override
  Widget toWidget(BuildContext context) =>
      SizedBox(width: double.maxFinite, child: _createWidget(context));

  Widget _createWidget(BuildContext context) {
    switch (type?.toLowerCase()) {
      case 'text':
        return TextButton(
          child: Text(caption),
          onPressed: () {
            action.execute(context, null);
          },
        );

      case 'outlined':
        return OutlinedButton(
          child: Text(caption),
          onPressed: () {
            action.execute(context, null);
          },
        );

      default:
        return ElevatedButton(
          child: Text(caption),
          onPressed: () {
            action.execute(context, null);
          },
        );
    }
  }

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    caption = json?["caption"] ?? '<NO-CAPTION>';
    type = json?["type"];
    return this;
  }
}
