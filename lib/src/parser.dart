import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'action.dart';
import 'appbar.dart';
import 'button.dart';
import 'column.dart';
import 'container.dart';
import 'dialog.dart';
import 'divider.dart';
import 'dropdown.dart';
import 'expanded.dart';
import 'flexible.dart';
import 'form.dart';
import 'icon.dart';
import 'icon_button.dart';
import 'image.dart';
import 'input.dart';
import 'list_view.dart';
import 'money.dart';
import 'page_view.dart';
import 'pin_with_keyboard.dart';
import 'radio.dart';
import 'row.dart';
import 'screen.dart';
import 'spacer.dart';
import 'text.dart';
import 'widget.dart';

//-- Core ------------------------------------
/// Parser that convert JSON to flutter [Widget]
class SDUIParser {
  static final SDUIParser _singleton = SDUIParser._internal();

  SDUIParser._internal();

  factory SDUIParser() {
    return _singleton;
  }

  static SDUIParser getInstance() => _singleton;

  Widget parseJson(String json, BuildContext context) {
    var data = jsonDecode(json);
    return fromJson(data).toWidget(context);
  }

  SDUIWidget fromJson(Map<String, dynamic> json) {
    var type = json["type"].toString().toLowerCase();
    SDUIWidget? widget;
    switch (type) {
      case "appbar":
        widget = SDUIAppBar();
        break;
      case "button":
        widget = SDUIButton();
        break;
      case "column":
        widget = SDUIColumn();
        break;
      case "container":
        widget = SDUIContainer();
        break;
      case "dialog":
        widget = SDUIDialog();
        break;
      case "divider":
        widget = SDUIDivider();
        break;
      case "dropdownbutton":
        widget = SDUIDropdownButton();
        break;
      case "dropdownmenuitem":
        widget = SDUIDropdownMenuItem();
        break;
      case "expanded":
        widget = SDUIExpanded();
        break;
      case "flexible":
        widget = SDUIFlexible();
        break;
      case "form":
        widget = SDUIForm();
        break;
      case "icon":
        widget = SDUIIcon();
        break;
      case "iconbutton":
        widget = SDUIIconButton();
        break;
      case "image":
        widget = SDUIImage();
        break;
      case "input":
        widget = SDUIInput();
        break;
      case "listview":
        widget = SDUIListView().fromJson(json);
        break;
      case "listitem":
        widget = SDUIListItem().fromJson(json);
        break;
      case "listitemswitch":
        widget = SDUIListItemSwitch().fromJson(json);
        break;
      case "moneytext":
        widget = SDUIMoneyText().fromJson(json);
        break;
      case "moneywithkeyboard":
        widget = SDUIMoneyWithKeyboard().fromJson(json);
        break;
      case "page":
        widget = SDUIPage().fromJson(json);
        break;
      case "pageview":
        widget = SDUIPageView().fromJson(json);
        break;
      case 'pinwithkeyboard':
        widget = SDUIPinWidthKeyboard().fromJson(json);
        break;
      case "radio":
        widget = SDUIRadio();
        break;
      case "radiogroup":
        widget = SDUIRadioGroup();
        break;
      case "screen":
        widget = SDUIScreen();
        break;
      case "spacer":
        widget = SDUISpacer();
        break;
      case "row":
        widget = SDUIRow();
        break;
      case "text":
        widget = SDUIText();
        break;

      default:
        throw Exception("Unsupported node: ${json["type"]}");
    }

    // Attributes
    var attributes = json["attributes"];
    if (attributes is Map<String, dynamic>) {
      widget.fromJson(attributes);
    }

    // Action
    var action = json["action"];
    if (action is Map<String, dynamic>) {
      widget.action = SDUIAction().fromJson(action);
    }

    // Children
    var child = json["child"];
    if (child is Map<String, dynamic>) {
      widget.children = [fromJson(child)];
    } else {
      var children = json["children"];
      if (children is List<dynamic>) {
        widget.children = children.map((e) => fromJson(e)).toList();
      }
    }

    // AppBar
    if (widget is SDUIScreen) {
      var appBar = json["appBar"];
      if (appBar is Map<String, dynamic>) {
        var item = fromJson(appBar);
        if (item is SDUIAppBar) {
          widget.appBar = item;
        }
      }
    }

    return widget;
  }
}
