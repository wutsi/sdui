import 'package:flutter/material.dart';

import 'appbar.dart';
import 'button.dart';
import 'route.dart';
import 'widget.dart';

class SDUIBottomNavigationBarItem extends SDUIWidget {
  String? caption;
  String? icon;

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

class SDUIBottomNavigationBar extends SDUIWidget{
  String? background;
  String? selectedItemColor;
  String? unselectedItemColor;
  double? iconSize;
  double? elevation;
  int? currentIndex;

  @override
  Widget toWidget(BuildContext context) => BottomNavigationBar(
      items: children.map((e) => BottomNavigationBarItem(
          icon: toIcon((e as SDUIBottomNavigationBarItem).icon) ?? const Icon(Icons.error),
          label: e.caption
      )).toList(),
      backgroundColor: toColor(background),
      selectedItemColor: toColor(selectedItemColor),
      unselectedItemColor: toColor(unselectedItemColor),
      iconSize: iconSize ?? 24.0,
      elevation: elevation,
      currentIndex: currentIndex ?? 0,
      onTap: (index) => action.execute(context, {}),
  );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    background = json?["background"];
    selectedItemColor = json?["selectedItemColor"];
    unselectedItemColor = json?["unselectedItemColor"];
    iconSize = json?["iconSize"];
    elevation= json?["elevation"];
    currentIndex =  json?["currentIndex"];
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
            resizeToAvoidBottomInset: false,
            backgroundColor: toColor(backgroundColor),
            appBar: appBar == null
                ? null
                : (appBar!.toWidget(context) as AppBar),
            body: safe == true
                ? SafeArea(child: _child(context))
                : _child(context),
            floatingActionButton: floatingActionButton?.toWidget(context),
            bottomNavigationBar: bottomNavigationBar?.toWidget(context)));

  Widget _child(BuildContext context) => hasChildren() ? child()!.toWidget(context) : Container();
}
