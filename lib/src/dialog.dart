import 'package:flutter/material.dart';

import 'parser.dart';
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
///    - `confirm`: Confirm dialog with `OK` and `Cancel` buttons.
class SDUIDialog extends SDUIWidget {
  String? title;
  String? message;
  String? type;
  List<SDUIWidget>? actions;

  @override
  Widget toWidget(BuildContext context) {
    List<Widget> children = [];
    Widget? icon = _icon();
    if (icon != null) {
      children.add(icon);
    }
    children.add(_content(message));

    return AlertDialog(
      title: title == null ? null : Text(title!),
      content: message == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
      actions: _actions(context),
    );
  }

  Widget? _icon() {
    switch (type?.toLowerCase()) {
      case 'error':
        return const Icon(Icons.error, color: Colors.red, size: 32);

      case 'warning':
        return const Icon(Icons.warning, color: Colors.yellow, size: 32);

      case 'information':
        return const Icon(Icons.info, color: Colors.blueAccent, size: 32);

      case 'confirm':
        return const Icon(Icons.help, color: Colors.blueAccent, size: 32);

      default:
        return null;
    }
  }

  Widget _content(String? text) => Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text ?? '',
        maxLines: 3,
        softWrap: true,
      ));

  List<Widget> _actions(BuildContext context) {
    if (actions != null) {
      return actions!.map((e) => e.toWidget(context)).toList();
    } else {
      switch (type?.toLowerCase()) {
        case 'confirm':
          return [
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'ok'),
                  child: const Text('OK'),
                )),
            SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel'),
                ))
          ];

        default:
          return [
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'ok'),
                  child: const Text('OK'),
                ))
          ];
      }
    }
  }

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    title = json?['title'];
    message = json?['message'];
    type = json?['type'];

    var actions = json?["actions"];
    if (actions is List<dynamic>) {
      this.actions = [];
      actions.map((it) => _parseAction(it)).forEach((it) {
        if (it != null) {
          it.action.inDialog =
              true; // Set this flag so that the dialog is clicked when executed
          this.actions?.add(it);
        }
      });
    }

    return this;
  }

  SDUIWidget? _parseAction(dynamic it) =>
      it is Map<String, dynamic> ? SDUIParser.getInstance().fromJson(it) : null;
}
