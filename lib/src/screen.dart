import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a screen, implemented as [Scaffold]
///
/// ### JSon Attribute
/// - *title*: Title to display in the application bar
/// - *safe*: if `true`, the content of the scafold will be enclosed in a [SafeArea]. Default=`false`
/// - *showAppBar*: if `true`, application bar will be visible. Default=`true`
class SDUIScreen extends SDUIWidget {
  String? title;
  bool safe = false;
  bool showAppBar = true;

  @override
  Widget toWidget(BuildContext context) {
    return Scaffold(
        appBar: showAppBar
            ? AppBar(
                title: title == null ? null : Text(title!),
              )
            : null,
        body: safe ? SafeArea(child: _child(context)) : _child(context));
  }

  Widget _child(BuildContext context) =>
      hasChildren() ? child()!.toWidget(context) : Container();

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    title = json?['title'];
    safe = json?['safe'] ?? false;
    showAppBar = json?['showAppBar'] ?? true;
    return this;
  }
}
