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
          : Row(children: [toIcon(icon!, size: 16)!, Text(caption)]));

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
  Widget toWidget(BuildContext context) => SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        value: value,
        hint: hint == null ? null : Text(hint!),
        onChanged: (value) => _onChanged(value),
        validator: (value) => _onValidate(value),
        items: _toItems(context),
      ));

  List<DropdownMenuItem<String>> _toItems(BuildContext context) {
    List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
    var children = childrenWidgets(context);
    for (var i = 0; i < children.length; i++) {
      var child = children[i];
      if (child is DropdownMenuItem<String>) {
        items.add(child);
      }
    }
    return items;
  }

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"] ?? '_no_name_';
    value = json?["value"];
    required = json?["required"];
    hint = json?["hint"];
    return super.fromJson(json);
  }

  void _onChanged(String? value) {
    provider?.setData(name, value ?? '');
  }

  String? _onValidate(String? value) {
    if (required == true && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    return null;
  }
}
