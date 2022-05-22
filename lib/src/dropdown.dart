import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:search_choices/search_choices.dart';

import 'form.dart';
import 'logger.dart';
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
  bool? stretched;
  bool? outlinedBorder;

  @override
  Widget toWidget(BuildContext context) => _DropdownButtonWidget(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"] ?? '_no_name_';
    value = json?["value"];
    required = json?["required"];
    hint = json?["hint"];
    stretched = json?["stretched"];
    outlinedBorder = json?["outlinedBorder"];
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

  void _onChanged(BuildContext context, String? value) {
    setState(() {
      state = value;

      delegate.provider?.setData(delegate.name, value ?? '');
      delegate.action.execute(context, {delegate.name: value}).then(
          (value) => delegate.action.handleResult(context, value));
    });
  }

  String? _onValidate(String? value) {
    if (delegate.required == true && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => delegate.stretched ?? true
      ? SizedBox(width: double.infinity, child: _button())
      : _button();

  DropdownButtonFormField _button() => DropdownButtonFormField<String>(
        value: state,
        hint: delegate.hint == null ? null : Text(delegate.hint!),
        decoration: delegate.outlinedBorder ?? true
            ? const InputDecoration(border: OutlineInputBorder(gapPadding: 2.0))
            : null,
        onChanged: (value) => _onChanged(context, value),
        validator: (value) => _onValidate(value),
        items: _toItems(context),
      );

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

/// Descriptor of a [SearchableDropdown]
class SDUISearchableDropdown extends SDUIWidget with SDUIFormField {
  String name = '_no_name_';
  String? value;
  String? hint;
  bool? required;

  @override
  Widget toWidget(BuildContext context) => _SearchableDropdownWidget(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"] ?? '_no_name_';
    value = json?["value"];
    required = json?["required"];
    hint = json?["hint"];
    return super.fromJson(json);
  }
}

class _SearchableDropdownWidget extends StatefulWidget {
  final SDUISearchableDropdown delegate;

  const _SearchableDropdownWidget(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _SearchableDropdownState(delegate);
}

class _SearchableDropdownState extends State<_SearchableDropdownWidget> {
  static final Logger _logger =
      LoggerFactory.create('_SearchableDropdownState');
  SDUISearchableDropdown delegate;
  String? state;

  _SearchableDropdownState(this.delegate);

  @override
  void initState() {
    super.initState();

    state = delegate.value;
    delegate.provider?.setData(delegate.name, state ?? '');
  }

  void _onChanged(String? value) {
    setState(() {
      state = value;
      delegate.provider?.setData(delegate.name, value ?? '');
    });
  }

  String? _onValidate(String? value) {
    if (delegate.required == true && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => SearchChoices.single(
        items: _toItems(context),
        onChanged: (value) => _onChanged(value),
        onClear: () => _onChanged(null),
        validator: (value) => _onValidate(value),
        hint: delegate.hint,
        value: state,
        isExpanded: true,
        searchFn: _search,
      );

  List<int> _search(String? keyword, List<DropdownMenuItem<String>> items) {
    _logger.i('...search keyword=$keyword');
    List<int> shownIndexes = [];
    int i = 0;
    for (var item in items) {
      if ((keyword?.isEmpty ?? true) || _matches(keyword!, item)) {
        shownIndexes.add(i);
      }
      i++;
    }
    return shownIndexes;
  }

  bool _matches(String keyword, DropdownMenuItem<String> item) {
    String? text = _toText(item.child);
    _logger.i('......keywordd=$keyword text=$text');
    return text == null || text.toLowerCase().contains(keyword.toLowerCase());
  }

  String? _toText(Widget child) {
    Text? text;
    if (child is Text) {
      text = child;
    } else if (child is Row) {
      for (var element in child.children) {
        if (element is Text) {
          text = element;
        }
      }
    }
    return text?.data;
  }

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
