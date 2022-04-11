import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'action.dart';
import 'appbar.dart';
import 'aspect_ratio.dart';
import 'badge.dart';
import 'button.dart';
import 'camera.dart';
import 'carousel_slider.dart';
import 'center.dart';
import 'chip.dart';
import 'circle_avatar.dart';
import 'column.dart';
import 'container.dart';
import 'dialog.dart';
import 'divider.dart';
import 'dropdown.dart';
import 'dynamic_widget.dart';
import 'expanded.dart';
import 'flexible.dart';
import 'form.dart';
import 'grid_view.dart';
import 'icon.dart';
import 'icon_button.dart';
import 'image.dart';
import 'input.dart';
import 'list_view.dart';
import 'logger.dart';
import 'money.dart';
import 'page_view.dart';
import 'photo_view.dart';
import 'pin_with_keyboard.dart';
import 'positioned.dart';
import 'qr_image.dart';
import 'qr_view.dart';
import 'radio.dart';
import 'row.dart';
import 'screen.dart';
import 'single_child_scroll_view.dart';
import 'spacer.dart';
import 'stack.dart';
import 'tab.dart';
import 'text.dart';
import 'widget.dart';
import 'wrap.dart';

//-- Core ------------------------------------
/// Parser that convert JSON to flutter [Widget]
class SDUIParser {
  static final Logger _logger = LoggerFactory.create('SDUIParser');
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
    var type = json["type"];
    var id = json["attributes"]?["id"];

    _logger.i('...Parsing $type' + (id == null ? '' : ' id=$id'));

    SDUIWidget? widget;
    switch (type?.toLowerCase()) {
      case "appbar":
        widget = SDUIAppBar();
        break;
      case "aspectratio":
        widget = SDUIAspectRatio();
        break;
      case "badge":
        widget = SDUIBadge();
        break;
      case "bottomnavigationbar":
        widget = SDUIBottomNavigationBar();
        break;
      case "bottomnavigationbaritem":
        widget = SDUIBottomNavigationBarItem();
        break;
      case "button":
        widget = SDUIButton();
        break;
      case "camera":
        widget = SDUICamera();
        break;
      case "carouselslider":
        widget = SDUICarouselSlider();
        break;
      case "center":
        widget = SDUICenter();
        break;
      case "chip":
        widget = SDUIChip();
        break;
      case "column":
        widget = SDUIColumn();
        break;
      case "circleavatar":
        widget = SDUICircleAvatar();
        break;
      case "container":
        widget = SDUIContainer();
        break;
      case "defaulttabcontroller":
        widget = SDUIDefaultTabController();
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
      case "dynamicwidget":
        widget = SDUIDynamicWidget();
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
      case "gridview":
        widget = SDUIGridView();
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
      case "moneywithslider":
        widget = SDUIMoneyWithSlider().fromJson(json);
        break;
      case "page":
        widget = SDUIPage().fromJson(json);
        break;
      case "pageview":
        widget = SDUIPageView().fromJson(json);
        break;
      case "photoview":
        widget = SDUIPhotoView().fromJson(json);
        break;
      case 'pinwithkeyboard':
        widget = SDUIPinWidthKeyboard().fromJson(json);
        break;
      case 'positioned':
        widget = SDUIPositioned().fromJson(json);
        break;
      case 'qrimage':
        widget = SDUIQrImage().fromJson(json);
        break;
      case 'qrview':
        widget = SDUIQrView().fromJson(json);
        break;
      case "radio":
        widget = SDUIRadio();
        break;
      case "radiogroup":
        widget = SDUIRadioGroup();
        break;
      case "searchabledropdown":
        widget = SDUISearchableDropdown();
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
      case "singlechildscrollview":
        widget = SDUISingleChildScrollView();
        break;
      case "stack":
        widget = SDUIStack();
        break;
      case "tab":
        widget = SDUITab();
        break;
      case "tabbar":
        widget = SDUITabBar();
        break;
      case "tabbarview":
        widget = SDUITabBarView();
        break;
      case "text":
        widget = SDUIText();
        break;
      case "wrap":
        widget = SDUIWrap();
        break;
      default:
        throw Exception("Unsupported node: ${json["type"]}");
    }

    // Attributes
    var attributes = json["attributes"];
    if (attributes == null) {
      _logger.i('......$type' +
          (id == null ? '' : '[id=$id]') +
          ' has no attributes');
    }
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

    if (widget is SDUIScreen) {
      // AppBar
      var appBar = json["appBar"];
      if (appBar is Map<String, dynamic>) {
        var item = fromJson(appBar);
        if (item is SDUIAppBar) {
          widget.appBar = item;
        }
      }

      // FloatingActionButton
      var floatingActionButton = json["floatingActionButton"];
      if (floatingActionButton is Map<String, dynamic>) {
        widget.floatingActionButton = fromJson(floatingActionButton);
      }

      // BottomNavigationBar
      var bottomNavigationBar = json["bottomNavigationBar"];
      if (bottomNavigationBar is Map<String, dynamic>) {
        SDUIWidget item = fromJson(bottomNavigationBar);
        if (item is SDUIBottomNavigationBar) {
          widget.bottomNavigationBar = item;
        }
      }
    }

    return widget;
  }
}
