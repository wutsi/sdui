import 'package:flutter/material.dart';

import 'appbar.dart';
import 'button.dart';
import 'widget.dart';

/// Descriptor of a screen, implemented as [Scaffold]
///
/// ### JSON Attribute
/// - *safe*: if `true`, the content of the scafold will be enclosed in a [SafeArea]. Default=`false`
/// - **backgroundColor**: Foreground color
/// - **floatingActionButton**: Floading button - [SDUIButton]
/// - *appBar***: Application Bar - [SDUIAppBar]
class SDUIScreen extends SDUIWidget {
  bool? safe;
  SDUIAppBar? appBar;
  String? backgroundColor;
  SDUIWidget? floatingActionButton;

  @override
  Widget toWidget(BuildContext context) => GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: toColor(backgroundColor),
          appBar: appBar == null ? null : (appBar!.toWidget(context) as AppBar),
          body:
              safe == true ? SafeArea(child: _child(context)) : _child(context),
          floatingActionButton: floatingActionButton?.toWidget(context)));

  Widget _child(BuildContext context) =>
      hasChildren() ? child()!.toWidget(context) : Container();

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    safe = json?['safe'];
    backgroundColor = json?["backgroundColor"];
    return super.fromJson(json);
  }
}
