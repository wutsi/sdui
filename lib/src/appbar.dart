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
/// - **bottom**: Bottom widget
class SDUIAppBar extends SDUIWidget {
  String? title;
  double? elevation;
  String? foregroundColor;
  String? backgroundColor;
  List<SDUIWidget>? actions;
  bool? automaticallyImplyLeading;
  SDUIWidget? leading;
  SDUIWidget? bottom;

  @override
  Widget toWidget(BuildContext context) => AppBar(
        title: title == null ? null : Text(title!, style: const TextStyle(fontSize: 12)),
        centerTitle: true,
        elevation: elevation,
        foregroundColor: toColor(foregroundColor),
        backgroundColor: toColor(backgroundColor),
        leading: leading?.toWidget(context),
        bottom: _bottomWidget(context),
        automaticallyImplyLeading: automaticallyImplyLeading ?? true,
        actions: actions?.map((e) => e.toWidget(context)).toList(),
      );

  PreferredSizeWidget? _bottomWidget(BuildContext context) {
    var widget = bottom?.toWidget(context);
    return widget is PreferredSizeWidget ? widget : null;
  }

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    title = json?["title"];
    elevation = json?["elevation"];
    foregroundColor = json?["foregroundColor"];
    backgroundColor = json?["backgroundColor"];
    leading = _parse(json?["leading"]);
    bottom = _parse(json?["bottom"]);
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
