import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [RadioListTile]
class SDUIRadio extends SDUIWidget {
  String? caption;
  String? subCaption;
  String? value;
  String? groupValue;

  @override
  Widget toWidget(BuildContext context) => RadioListTile<String>(
        title: Text(caption ?? '<NO-TITLE>'),
        subtitle: subCaption == null ? null : Text(subCaption ?? ''),
        value: value ?? '',
        groupValue: groupValue,
        onChanged: (v) {},
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    caption = json?["caption"];
    subCaption = json?["subCaption"];
    value = json?["value"];
    return this;
  }
}

/// Descriptor of a radio group
class SDUIRadioGroup extends SDUIWidget {
  String? name;
  String? value;

  @override
  Widget toWidget(BuildContext context) => RadioGroupWidget(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    name = json?["name"];
    value = json?["value"];
    return this;
  }
}

class RadioGroupWidget extends StatefulWidget {
  final SDUIRadioGroup delegate;

  const RadioGroupWidget(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  RadioGroupState createState() => RadioGroupState(delegate);
}

class RadioGroupState extends State<RadioGroupWidget> {
  String state = '';
  SDUIRadioGroup delegate;

  RadioGroupState(this.delegate);

  @override
  void initState() {
    super.initState();
    state = delegate.value ?? '';
  }

  @override
  Widget build(BuildContext context) => ListView(
          children: delegate.children.map((e) {
        if (e is SDUIRadio) {
          return RadioListTile<String>(
              title: Text(e.caption ?? '<NO-TITLE>'),
              subtitle: e.subCaption == null ? null : Text(e.subCaption ?? ''),
              value: e.value ?? '',
              groupValue: state,
              onChanged: (String? v) => _onChange(context, v));
        } else {
          return e.toWidget(context);
        }
      }).toList());

  void _onChange(BuildContext context, String? value) {
    var val = value ?? '';

    setState(() {
      state = val;
    });

    var data = <String, String>{};
    data[(delegate.name ?? '_no_name')] = val;
    delegate.action.execute(context, data);
  }
}
