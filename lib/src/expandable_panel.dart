import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of [ExpandablePanel].
class SDUIExpandablePanel extends SDUIWidget {
  String? header;
  String? collapsed;

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    header = json?["header"];
    collapsed = json?["collapsed"];
    return super.fromJson(json);
  }

  @override
  Widget toWidget(BuildContext context) => ExpandablePanel(
        header: header == null
            ? null
            : Container(
                alignment: Alignment.centerLeft,
                height: (ExpandableThemeData.defaults.iconSize ?? 24.0) +
                    (ExpandableThemeData.defaults.iconPadding?.top ?? 8.0) +
                    (ExpandableThemeData.defaults.iconPadding?.bottom ?? 8.0),
                padding: ExpandableThemeData.defaults.iconPadding,
                child: Text(header!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
        collapsed: collapsed == null ? Container() : Text(collapsed!),
        expanded: hasChildren() ? children[0].toWidget(context) : Container(),
      );
}
