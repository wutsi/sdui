import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

/// Descriptor of an [AppBar].
///
/// ### JSON Attributes
/// - **title**: Title
/// - **elevation**: Elevation
/// - **foregroundColor**: Foreground color
/// - **backgroundColor**: Backgroupnd color
/// - **automaticallyImplyLeading**: Imply leading widget (default=true)
/// - **leading**: action on LHS
/// - **actions**: List of actions to add on RHS
class SDUIAppBar extends SDUIWidget {
  String? title;
  double? elevation;
  String? foregroundColor;
  String? backgroundColor;
  List<SDUIWidget>? actions;
  bool? automaticallyImplyLeading;
  SDUIWidget? leading;

  @override
  Widget toWidget(BuildContext context) => AppBar(
      title: title == null ? null : Text(title!),
      centerTitle: true,
      elevation: elevation,
      foregroundColor: toColor(foregroundColor),
      backgroundColor: toColor(backgroundColor),
      leading: leading?.toWidget(context),
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      actions: actions?.map((e) => e.toWidget(context)).toList());

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    title = json?["title"];
    elevation = json?["elevation"];
    foregroundColor = json?["foregroundColor"];
    backgroundColor = json?["backgroundColor"];
    leading = _parse(json?["leading"]);
    automaticallyImplyLeading = json?["automaticallyImplyLeading"];

    var actions = json?["actions"];
    if (actions is List<dynamic>) {
      this.actions = [];
      actions.map((it) => _parse(it)).forEach((it) {
        if (it != null) {
          this.actions?.add(it);
        }
      });
    }

    return this;
  }

  SDUIWidget? _parse(dynamic it) =>
      it is Map<String, dynamic> ? SDUIParser.getInstance().fromJson(it) : null;
}
