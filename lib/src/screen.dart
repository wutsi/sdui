import 'package:flutter/material.dart';

import 'appbar.dart';
import 'widget.dart';

/// Descriptor of a screen, implemented as [Scaffold]
///
/// ### JSON Attribute
/// - *safe*: if `true`, the content of the scafold will be enclosed in a [SafeArea]. Default=`false`
/// - *appBar***: description of the [SDUIAppBar]
/// - **backgroundColor**: Foreground color
class SDUIScreen extends SDUIWidget {
  bool? safe;
  SDUIAppBar? appBar;
  String? backgroundColor;

  @override
  Widget toWidget(BuildContext context) => GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: toColor(backgroundColor),
        appBar: appBar == null ? null : (appBar!.toWidget(context) as AppBar),
        body: safe == true ? SafeArea(child: _child(context)) : _child(context),
      ));

  Widget _child(BuildContext context) =>
      hasChildren() ? child()!.toWidget(context) : Container();

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    safe = json?['safe'];
    backgroundColor = json?["backgroundColor"];
    return super.fromJson(json);
  }
}
