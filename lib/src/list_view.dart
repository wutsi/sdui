import 'package:flutter/material.dart';

import 'form.dart';
import 'parser.dart';
import 'widget.dart';

/// Descriptor of a [ListView]
class SDUIListView extends SDUIWidget {
  String? direction;
  bool? separator;
  String? separatorColor;

  @override
  Widget toWidget(BuildContext context) =>
      ListView(
          scrollDirection: toAxis(direction),
          children: childrenWidgets(context)
              .map((e) => _toListItem(e))
              .toList());

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    direction = json?["direction"];
    separator = json?["separator"];
    separatorColor = json?["separatorColor"];
    return super.fromJson(json);
  }

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
  Widget toWidget(BuildContext context) =>
      ListTile(
        key: id == null ? null : Key(id!),
        title: Text(caption ?? '<NO-TITLE>'),
        subtitle: subCaption == null ? null : Text(subCaption!),
        leading: leading?.toWidget(context) ?? toIcon(iconLeft, size: 48),
        trailing: trailing?.toWidget(context) ?? toIcon(iconRight, size: 48),
        contentPadding: padding == null ? null : EdgeInsets.all(padding!),
        onTap: () {
          action
              .execute(context, null)
              .then((value) => action.handleResult(context, value));
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
    return super.fromJson(json);
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
    icon = json?["icon"];
    name = json?["name"] ?? '_no_name_';
    selected = json?["selected"] ?? false;
    return super.fromJson(json);
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
  bool buzy = false;
  SDUIListItemSwitch delegate;

  _ListItemSwitchState(this.delegate);

  @override
  void initState() {
    super.initState();

    delegate.provider?.setData(delegate.name, delegate.selected.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      key: delegate.id == null ? null : Key(delegate.id!),
      value: delegate.selected,
      title: Text(delegate.caption ?? '<NO-TITLE>'),
      subtitle: delegate.subCaption == null ? null : Text(delegate.subCaption!),
      secondary: delegate.toIcon(delegate.icon),
      onChanged: buzy ? null : (bool value) => _changeState(value),
    );
  }

  void _changeState(bool value) {
    setState(() {
      buzy = true;
    });
    submit(context, value);
  }

  void submit(BuildContext context, bool value) {
    delegate.provider?.setData(delegate.name, value.toString());

    delegate.action.execute(context, {delegate.name: value}).then((value) {
      delegate.action.handleResult(context, value);
    }).whenComplete(() =>
        setState(() {
          buzy = false;
        }));
  }
}
