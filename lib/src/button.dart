import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:sdui/src/logger.dart';

import 'action.dart';
import 'analytics.dart';
import 'widget.dart';

/// Descriptor of a button
///
/// ### JSON Attributes
///  - *caption*: Caption of the button
///  - *padding*: Button padding (default = 15).
///  - *stretched*: if `true`, the button will be stretched (default = true)
///  - *type*: Type of button. The values are:
///     - `elevated` for [ElevatedButton] (default)
///     - `text` for [TextButton]
///     - `outlined` for [OutlinedButton]
/// - *icon*: Icon code
/// - *iconSize*: Size of the icon
/// - *action***: [SDUIAction] to execute when the button is clicked
class SDUIButton extends SDUIWidget {
  String? caption;
  String? type;
  double? padding;
  bool? stretched;
  String? icon;
  double? iconSize;
  ActionCallback? onPressed;

  SDUIButton(
      {this.caption,
      this.type,
      this.padding,
      this.onPressed,
      this.stretched,
      this.iconSize,
      this.icon});

  @override
  Widget toWidget(BuildContext context) => _ButtonWidgetStateful(this);

  Future<String?> _onSubmit(BuildContext context) =>
      onPressed == null ? action.execute(context, null) : onPressed!(context);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    caption = json?["caption"];
    type = json?["type"];
    padding = json?["padding"];
    stretched = json?["stretched"];
    icon = json?["icon"];
    iconSize = json?["iconSize"];
    return super.fromJson(json);
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
  static final Logger _logger = LoggerFactory.create('_ButtonWidgetState');

  bool busy = false;
  SDUIButton delegate;

  _ButtonWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => delegate.stretched == false
      ? _createWidget()
      : SizedBox(width: double.infinity, child: _createWidget());

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

  Widget _createText() {
    Widget? child;

    if (busy) {
      child = SizedBox(
          width: 13,
          height: 13,
          child: CircularProgressIndicator(
            color: (delegate.type?.toLowerCase() == "text") ||
                    (delegate.type?.toLowerCase() == "outlined")
                ? null
                : Colors.white,
            strokeWidth: 2,
          ));
    } else {
      if (delegate.icon == null) {
        child = Text(delegate.caption ?? '');
      } else {
        child = Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            delegate.toIcon(delegate.icon,
                size: delegate.iconSize, color: "#ffffff")!,
            Text(delegate.caption ?? '')
          ],
        );
      }
    }

    return Padding(
        padding: EdgeInsets.all(delegate.padding ?? 15), child: child);
  }

  void _onSubmit(BuildContext context) {
    if (busy) {
      return;
    }

    _busy(true);
    _notifyAnalytics();
    delegate
        ._onSubmit(context)
        .then((value) => _handleResult(value))
        .onError(
            (error, stackTrace) => _handleError(context, error, stackTrace))
        .whenComplete(() => _busy(false));
  }

  void _notifyAnalytics() {
    try {
      String? id = delegate.id;
      if (id != null) {
        sduiAnalytics.onClick(id);
      }
    } catch (e) {
      _logger.w("Unable to push event to Analytics", e);
    }
  }

  Future<String?> _handleResult(String? result) {
    if (result == null) {
      return Future.value(null);
    }

    var json = jsonDecode(result);
    if (json is Map<String, dynamic>) {
      var action = SDUIAction().fromJson(json);
      action.pageController = delegate.action.pageController;
      return action
          .execute(context, json)
          .then((value) => _handleResult(value));
    }
    return Future.value(null);
  }

  Future<String?> _handleError(
      BuildContext context, Object? error, StackTrace stackTrace) {
    if (error is ClientException) {
      _logger.e('FAILURE - POST ${error.uri}', error, stackTrace);
    } else {
      _logger.e('FAILURE', error, stackTrace);
    }
    return Future.value(null);
  }

  void _busy(bool value) {
    setState(() {
      busy = value;
    });
  }
}
