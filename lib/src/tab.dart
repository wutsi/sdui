import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sdui/sdui.dart';

/// Descriptor of an [DefaultTabController].
///
/// ### JSON Attributes
/// - **length**: Number of tabs
/// - **initialIndex**: Initial tab index (default = 0)
class SDUIDefaultTabController extends SDUIWidget {
  int length = 1;
  int initialIndex = 0;

  @override
  Widget toWidget(BuildContext context) => OverlaySupport(
          child: DefaultTabController(
        key: id == null ? null : Key(id!),
        length: length,
        initialIndex: initialIndex,
        child: child()!.toWidget(context),
      ));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    length = json?["length"] ?? 1;
    initialIndex = json?["initialIndex"] ?? 0;
    return super.fromJson(json);
  }
}

/// Descriptor of an [Tab].
///
/// ### JSON Attributes
/// - **icon**: Icon
/// - **caption**: Caption
class SDUITab extends SDUIWidget {
  String? icon;
  String? caption;

  @override
  Widget toWidget(BuildContext context) => caption == null
      ? Tab(icon: toIcon(icon))
      : Column(
          children: [toIcon(icon) ?? const Icon(Icons.error), Text(caption!)]);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    icon = json?["icon"];
    caption = json?["caption"];
    return super.fromJson(json);
  }
}

/// Descriptor of an [TabBar].
class SDUITabBar extends SDUIWidget {
  @override
  Widget toWidget(BuildContext context) =>
      TabBar(tabs: childrenWidgets(context));
}

/// Descriptor of an [TabBarView].
class SDUITabBarView extends SDUIWidget {
  @override
  Widget toWidget(BuildContext context) =>
      TabBarView(children: childrenWidgets(context));
}
