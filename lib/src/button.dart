import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'action.dart';
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
/// - *action***: [SDUIAction] to execute when the button is clicked
class SDUIButton extends SDUIWidget {
  String? caption;
  String? type;
  double? padding;
  ActionCallback? onPressed;

  SDUIButton({this.caption, this.type, this.padding, this.onPressed});

  @override
  Widget toWidget(BuildContext context) => _ButtonWidgetStateful(this);

  Future<String?> _onSubmit(BuildContext context) =>
      onPressed == null ? action.execute(context, null) : onPressed!(context);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    caption = json?["caption"];
    type = json?["type"];
    padding = json?["padding"];
    return this;
  }
}

class _ButtonWidgetStateful extends StatefulWidget {
  final SDUIButton delegate;

  const _ButtonWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _ButtonWidgetState(delegate);
}

class _ButtonWidgetState extends State<_ButtonWidgetStateful> {
  static final Logger _logger = Logger();
  bool busy = false;
  SDUIButton delegate;

  _ButtonWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: double.infinity, child: _createWidget());

  Widget _createWidget() {
    switch (delegate.type?.toLowerCase()) {
      case 'text':
        return TextButton(
          child: _createText(),
          onPressed: () => _onSubmit(context),
        );

      case 'outlined':
        return OutlinedButton(
          child: _createText(),
          onPressed: () => _onSubmit(context),
        );

      default:
        return ElevatedButton(
          child: _createText(),
          onPressed: () => _onSubmit(context),
        );
    }
  }

  Widget _createText() => Padding(
      padding: EdgeInsets.all(delegate.padding ?? 15),
      child: busy
          ? const SizedBox(
              width: 13,
              height: 13,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ))
          : Text(delegate.caption ?? 'Button'));

  void _onSubmit(BuildContext context) {
    if (busy) {
      return;
    }

    _busy(true);
    delegate
        ._onSubmit(context)
        .then((value) => _handleResult(value))
        .onError(
            (error, stackTrace) => _handleError(context, error, stackTrace))
        .whenComplete(() => _busy(false));
  }

  void _handleResult(String? result) {
    if (result == null) {
      return;
    }

    var json = jsonDecode(result);
    if (json is Map<String, dynamic>) {
      var action = SDUIAction().fromJson(json);
      action.pageController = delegate.action.pageController;
      action.execute(context, json);
    }
  }

  void _handleError(
      BuildContext context, Object? error, StackTrace stackTrace) {
    _logger.e('FAILURE', error, stackTrace);
  }

  void _busy(bool value) {
    setState(() {
      busy = value;
    });
  }
}
