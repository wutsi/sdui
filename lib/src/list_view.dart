import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sdui/sdui.dart';

import 'form.dart';
import 'widget.dart';

/// Descriptor of a [ListView]
class SDUIListView extends SDUIWidget {
  String? direction;
  bool? separator;
  String? separatorColor;

  @override
  Widget toWidget(BuildContext context) => ListView(
      children: childrenWidgets(context).map((e) => _toListItem(e)).toList(),
      scrollDirection: _toScrollDirection());

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    direction = json?["direction"];
    separator = json?["separator"];
    separatorColor = json?["separatorColor"];
    return this;
  }

  Axis _toScrollDirection() => direction?.toLowerCase() == "horizontal"
      ? Axis.horizontal
      : Axis.vertical;

  Widget _toListItem(Widget item) {
    if (separator == true) {
      return Column(
        children: [
          item,
          Divider(
            height: 1,
            color: toColor(separatorColor),
          )
        ],
      );
    } else {
      return item;
    }
  }
}

/// Descriptor of a [ListTile]
class SDUIListItem extends SDUIWidget {
  String? caption;
  String? subCaption;
  String? iconLeft;
  String? iconRight;
  double? padding;
  SDUIWidget? leading;
  SDUIWidget? trailing;

  SDUIListItem({this.caption, this.subCaption, this.iconLeft, this.iconRight});

  @override
  Widget toWidget(BuildContext context) => ListTile(
        title: Text(caption ?? '<NO-TITLE>'),
        subtitle: subCaption == null ? null : Text(subCaption!),
        leading: leading?.toWidget(context) ?? toIcon(iconLeft, size: 48),
        trailing: trailing?.toWidget(context) ?? toIcon(iconRight, size: 48),
        contentPadding: padding == null ? null : EdgeInsets.all(padding!),
        onTap: () {
          action.execute(context, null);
        },
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    caption = json?["caption"];
    subCaption = json?["subCaption"];
    iconLeft = json?["iconLeft"];
    iconRight = json?["iconRight"];
    padding = json?["padding"];
    leading = _parseWidget('leading', json);
    trailing = _parseWidget('trailing', json);
    return this;
  }

  SDUIWidget? _parseWidget(String name, Map<String, dynamic>? json) {
    var dom = json?[name];
    if (dom is Map<String, dynamic>) {
      try {
        return SDUIParser.getInstance().fromJson(dom);
      } catch (e) {
        // Nothing
      }
    }
    return null;
  }
}

/// Descriptor of a [SwitchListTile]
class SDUIListItemSwitch extends SDUIWidget with SDUIFormField {
  bool selected = false;
  String name = '';
  String? caption;
  String? subCaption;
  String? icon;

  @override
  Widget toWidget(BuildContext context) => _ListItemSwitchWidget(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    caption = json?["caption"];
    subCaption = json?["subCaption"];
    icon = json?["leftIcon"];
    name = json?["name"] ?? '_no_name_';
    selected = json?["selected"] ?? false;
    return this;
  }

  void submit(BuildContext context, String value) {
    var data = <String, String>{};
    data[name] = value;
    action.execute(context, data);
  }
}

class _ListItemSwitchWidget extends StatefulWidget {
  final SDUIListItemSwitch delegate;

  const _ListItemSwitchWidget(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _ListItemSwitchState createState() => _ListItemSwitchState(delegate);
}

class _ListItemSwitchState extends State<_ListItemSwitchWidget> {
  bool state = false;
  SDUIListItemSwitch delegate;

  _ListItemSwitchState(this.delegate);

  @override
  void initState() {
    super.initState();
    state = delegate.selected;
    delegate.provider?.setData(delegate.name, state.toString());
  }

  @override
  Widget build(BuildContext context) => SwitchListTile(
        value: state,
        title: Text(delegate.caption ?? '<NO-TITLE>'),
        subtitle:
            delegate.subCaption == null ? null : Text(delegate.subCaption!),
        secondary: delegate.toIcon(delegate.icon),
        onChanged: (bool value) => _changeState(value),
      );

  void _changeState(bool value) {
    setState(() => state = value);
    delegate.submit(context, value.toString());
    delegate.provider?.setData(delegate.name, value.toString());
  }
}
