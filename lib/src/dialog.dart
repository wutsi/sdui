import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [AlertDialog]
///
/// ### JSON Attributes
/// - **title**: Title of the dialog
/// - **message**: Message to display
/// - **type**: Type of alert dialog:
///    - `error`: Show an error message
///    - `warning`: Show an warning message
///    - `information`: Show an information message
///    - `alert`: Alert dialog with `OK` button. (default)
///    - `config`: Confirm dialog with `OK` and `Cancel` buttons.
class SDUIDialog extends SDUIWidget {
  String? title;
  String? message;
  String? type;

  @override
  Widget toWidget(BuildContext context) {
    switch (type?.toLowerCase()) {
      case 'error':
        return _message(context, Icons.error, Colors.red);

      case 'warning':
        return _message(context, Icons.warning, Colors.yellow);

      case 'information':
        return _message(context, Icons.info, Colors.blueAccent);

      case 'confirm':
        return _confirm(context);

      default:
        return _alert(context);
    }
  }

  Widget _confirm(BuildContext context) => AlertDialog(
        title: title == null ? null : Text(title!),
        content: _content(message),
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
        content: _content(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'ok'),
            child: const Text('OK'),
          )
        ],
      );

  Widget _message(BuildContext context, IconData iconData, Color color) =>
      AlertDialog(
        title: title == null ? null : Text(title!),
        content: message == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconData, color: color, size: 48),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: _content(message),
                  )
                ],
              ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'ok'),
            child: const Text('OK'),
          )
        ],
      );

  Widget _content(String? text) => Text(
        text ?? '',
        maxLines: 3,
        softWrap: true,
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    title = json?['title'];
    message = json?['message'];
    type = json?['type'];
    return this;
  }
}
