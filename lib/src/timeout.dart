import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'http.dart';
import 'loading.dart';
import 'logger.dart';
import 'noop.dart';
import 'parser.dart';
import 'widget.dart';

/// Descriptor of a Timeout component
///
/// ### JSON Attributes
///  - *delay*: Delay in seconds
///  - *url*: URL to poll every <delay>
class SDUITimeout extends SDUIWidget {
  String? url;
  int? delay;

  @override
  Widget toWidget(BuildContext context) => _TimeoutStatefulWidget(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    url = json?["url"];
    delay = json?["delay"];
    return super.fromJson(json);
  }
}

class _TimeoutStatefulWidget extends StatefulWidget {
  final SDUITimeout delegate;

  const _TimeoutStatefulWidget(this.delegate);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _TimeoutState(delegate);
}

class _TimeoutState extends State<_TimeoutStatefulWidget> {
  static final Logger _logger = LoggerFactory.create('_TimeoutState');

  final SDUITimeout delegate;
  SDUIWidget? _widget;
  int count = 0;

  _TimeoutState(this.delegate);

  @override
  void initState() {
    super.initState();

    Timer.periodic(
        Duration(seconds: delegate.delay ?? 15), (timer) => _call(timer));
  }

  @override
  Widget build(BuildContext context) => _widget == null
      ? Center(child: sduiProgressIndicator(context))
      : _widget!.toWidget(context);

  void _call(Timer timer) {
    if (delegate.url == null) return;

    count++;
    var url = delegate.url!;
    if (url.indexOf("?") > 0) {
      url += "&count=$count";
    } else {
      url += "?count=$count";
    }

    _logger.i('$count - Invoking $url');
    Http.getInstance().post(url, {}).then((value) => initWidget(value, timer));
  }

  void initWidget(String json, Timer timer) {
    try {
      SDUIWidget widget = SDUIParser().fromJson(jsonDecode(json));
      if (widget is! SDUINoop) {
        _logger.i('DONE: widget: $widget');
        timer.cancel();
        setState(() {
          _widget = widget;
        });
      } else {
        _logger.i('CONTINUE: widget: $widget');
      }
    } catch (e) {
      _logger.w('Invalid json: $json', e);
    }
  }
}
