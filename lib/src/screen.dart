import 'package:flutter/material.dart';

import 'appbar.dart';
import 'button.dart';
import 'widget.dart';

class SDUIBottomNavigationBarItem extends SDUIWidget {
  String? caption;
  String? icon;

  @override
  SDUIBottomNavigationBarItem fromJson(Map<String, dynamic>? json) {
    caption = json?["caption"];
    icon = json?["icon"];
    return this;
  }

  @override
  Widget toWidget(BuildContext context) {
    throw UnimplementedError();
  }
}

class SDUIBottomNavigationBar extends SDUIWidget {
  String? background;
  String? selectedItemColor;
  String? unselectedItemColor;
  double? iconSize;
  double? fontSize;
  double? elevation;
  int? currentIndex;

  @override
  Widget toWidget(BuildContext context) {
    List<BottomNavigationBarItem> items = children
        .map((e) => BottomNavigationBarItem(
            icon: toIcon((e as SDUIBottomNavigationBarItem).icon) ??
                const Icon(Icons.error),
            label: e.caption))
        .toList();
    return BottomNavigationBar(
      items: items,
      backgroundColor: toColor(background),
      selectedItemColor: toColor(selectedItemColor),
      unselectedItemColor: toColor(unselectedItemColor),
      iconSize: iconSize ?? 18.0,
      unselectedFontSize: fontSize ?? 10.0,
      selectedFontSize: fontSize ?? 10.0,
      elevation: elevation,
      currentIndex: currentIndex ?? 0,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => (children[index] as SDUIBottomNavigationBarItem)
          .action
          .execute(context, {}).then(
              (value) => children[index].action.handleResult(context, value)),
    );
  }

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    background = json?["background"];
    selectedItemColor = json?["selectedItemColor"];
    unselectedItemColor = json?["unselectedItemColor"];
    iconSize = json?["iconSize"];
    elevation = json?["elevation"];
    currentIndex = json?["currentIndex"];
    fontSize = json?["fontSize"];
    return super.fromJson(json);
  }
}

/// Descriptor of a screen, implemented as [Scaffold]
///
/// ### JSON Attribute
/// - *safe*: if `true`, the content of the scafold will be enclosed in a [SafeArea]. Default=`false`
/// - **backgroundColor**: Foreground color
/// - **floatingActionButton**: Floading button - [SDUIButton]
/// - *appBar***: Application Bar - [SDUIAppBar]
class SDUIScreen extends SDUIWidget {
  bool? safe;
  String? backgroundColor;
  SDUIAppBar? appBar;
  SDUIWidget? floatingActionButton;
  SDUIBottomNavigationBar? bottomNavigationBar;

  @override
  Widget toWidget(BuildContext context) => GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          key: id == null ? null : Key(id!),
          resizeToAvoidBottomInset: false,
          backgroundColor: toColor(backgroundColor),
          appBar: appBar == null ? null : (appBar!.toWidget(context) as AppBar),
          body:
              safe == true ? SafeArea(child: _child(context)) : _child(context),
          floatingActionButton: floatingActionButton?.toWidget(context),
          bottomNavigationBar: bottomNavigationBar?.toWidget(context)));

  Widget _child(BuildContext context) =>
      hasChildren() ? child()!.toWidget(context) : Container();

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    safe = json?["safe"];
    backgroundColor = json?["backgroundColor"];
    return super.fromJson(json);
  }

  @override
  void attachScreen(SDUIWidget screen) {
    appBar?.attachScreen(screen);
    bottomNavigationBar?.attachScreen(screen);

    super.attachScreen(screen);
  }
}
