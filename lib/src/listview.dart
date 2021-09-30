import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'widget.dart';

/// Descriptor of a [ListView]
class SDUIListView extends SDUIWidget {
  String? direction;
  bool? separator;

  @override
  Widget toWidget(BuildContext context) => ListView(
      children: childrenWidgets(context).map((e) => _toListItem(e)).toList(),
      scrollDirection: _toScrollDirection());

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    direction = json?["direction"];
    separator = json?["separator"];
    return this;
  }

  Axis _toScrollDirection() => direction?.toLowerCase() == "horizontal"
      ? Axis.horizontal
      : Axis.vertical;

  Widget _toListItem(Widget item) {
    if (separator == true) {
      return Column(
        children: [item, const Divider(height: 1)],
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
  String? leftIcon;
  String? rightIcon;

  SDUIListItem({this.caption, this.subCaption, this.leftIcon, this.rightIcon});

  @override
  Widget toWidget(BuildContext context) => ListTile(
        title: Text(caption ?? '<NO-TITLE>'),
        subtitle: subCaption == null ? null : Text(subCaption!),
        leading: toIcon(leftIcon),
        trailing: toIcon(rightIcon),
        onTap: () {
          action.execute(context, null);
        },
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    caption = json?["caption"];
    subCaption = json?["subCaption"];
    leftIcon = json?["leftIcon"];
    rightIcon = json?["rightIcon"];
    return this;
  }
}

/// Descriptor of a [SwitchListTile]
class SDUIListItemSwitch extends SDUIWidget {
  bool selected = false;
  String name = '';
  String? caption;
  String? subCaption;
  String? icon;

  @override
  Widget toWidget(BuildContext context) => ListItemSwitchWidget(this);

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

class ListItemSwitchWidget extends StatefulWidget {
  final SDUIListItemSwitch delegate;

  const ListItemSwitchWidget(this.delegate, {Key? key}) : super(key: key);

  @override
  ListItemSwitchState createState() => ListItemSwitchState(delegate);
}

class ListItemSwitchState extends State<ListItemSwitchWidget> {
  bool state = false;
  SDUIListItemSwitch delegate;

  ListItemSwitchState(this.delegate);

  @override
  void initState() {
    super.initState();
    state = delegate.selected;
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
  }
}
