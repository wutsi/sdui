import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

/// Descriptor of an [AppBar].
///
/// ### JSON Attributes
/// - **title**: Title
class SDUIAppBar extends SDUIWidget {
  String? title;

  @override
  Widget toWidget(BuildContext context) => AppBar(
        title: title == null ? null : Text(title!),
        actions: childrenWidgets(context),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    title = json?["title"];
    return super.fromJson(json);
  }
}
