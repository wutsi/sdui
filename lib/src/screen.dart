import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a screen, implemented as [Scaffold]
class SDUIScreen extends SDUIWidget {
  String? title;

  SDUIScreen({this.title});

  @override
  Widget toWidget(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? ''),
        ),
        body: child()?.toWidget(context));
  }

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    title = json?['title'];
    return this;
  }
}
