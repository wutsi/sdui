import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [AlertDialog]
///
/// ### JSON Attributes
/// - **title**: Title of the dialog
/// - **message**: Message to display
/// - **type**: Type of alert dialog:
///    - `alert`: Alert dialog with `OK` button. (default)
///    - `config`: Confirm dialog with `OK` and `Cancel` buttons.
class SDUIDialog extends SDUIWidget {
  String? title;
  String? message;
  String? type;

  @override
  Widget toWidget(BuildContext context) {
    switch (type?.toLowerCase()) {
      case 'confirm':
        return _confirm(context);

      default:
        return _alert(context);
    }
  }

  Widget _confirm(BuildContext context) => AlertDialog(
        title: title == null ? null : Text(title!),
        content: message == null ? null : Text(message!),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'ok'),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          )
        ],
      );

  Widget _alert(BuildContext context) => AlertDialog(
        title: title == null ? null : Text(title!),
        content: message == null ? null : Text(message!),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'ok'),
            child: const Text('OK'),
          )
        ],
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    title = json?['title'];
    message = json?['message'];
    type = json?['type'];
    return this;
  }
}
