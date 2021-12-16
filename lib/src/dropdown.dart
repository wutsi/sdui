import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'form.dart';
import 'widget.dart';

/// Descriptor of a widget [DropdownMenuItem].
///
/// ### JSON Attributes
/// - **caption**: Text of the item
/// - **enabled**: Is the item enabled? (Default=true)
/// - **icon**: Icon code. See [IconData]
/// - **value**: Value associated with the icon
class SDUIDropdownMenuItem extends SDUIWidget {
  String caption = '<empty>';
  String value = '<empty>';
  bool enabled = true;
  String? icon;

  @override
  Widget toWidget(BuildContext context) => DropdownMenuItem<String>(
      enabled: enabled,
      value: value,
      alignment: Alignment.centerLeft,
      child: icon == null
          ? Text(caption)
          : Row(children: [
              SizedBox(
                  width: 24,
                  height: 24,
                  child: FittedBox(child: toIcon(icon!, size: 24)!)),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(caption),
              )
            ]));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    caption = json?["caption"] ?? '<empty>';
    enabled = json?["enabled"] ?? true;
    icon = json?["icon"];
    value = json?["value"] ?? caption;
    return super.fromJson(json);
  }
}

/// Descriptor of a [DropdownButtonFormField]
class SDUIDropdownButton extends SDUIWidget with SDUIFormField {
  String name = '_no_name_';
  String? value;
  String? hint;
  bool? required;

  @override
  Widget toWidget(BuildContext context) => _DropdownButtonWidget(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"] ?? '_no_name_';
    value = json?["value"];
    required = json?["required"];
    hint = json?["hint"];
    return super.fromJson(json);
  }
}

class _DropdownButtonWidget extends StatefulWidget {
  final SDUIDropdownButton delegate;

  const _DropdownButtonWidget(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _DropdownButtonWidgetState(delegate);
}

class _DropdownButtonWidgetState extends State<_DropdownButtonWidget> {
  SDUIDropdownButton delegate;
  String? state;

  _DropdownButtonWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();

    state = delegate.value;
    delegate.provider?.setData(delegate.name, state ?? '');
  }

  void _onChanged(String? value) {
    delegate.provider?.setData(delegate.name, value ?? '');
  }

  String? _onValidate(String? value) {
    if (delegate.required == true && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        value: state,
        hint: delegate.hint == null ? null : Text(delegate.hint!),
        onChanged: (value) => _onChanged(value),
        validator: (value) => _onValidate(value),
        items: _toItems(context),
      ));

  List<DropdownMenuItem<String>> _toItems(BuildContext context) {
    List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
    var children = delegate.childrenWidgets(context);
    for (var i = 0; i < children.length; i++) {
      var child = children[i];
      if (child is DropdownMenuItem<String>) {
        items.add(child);
      }
    }
    return items;
  }
}
