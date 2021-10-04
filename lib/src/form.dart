import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of [Form]
class SDUIForm extends SDUIWidget {
  /// Padding to apply to each child of the form
  double? padding;

  @override
  Widget toWidget(BuildContext context) => _FormWidgetStateful(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    padding = json?["padding"];
    return this;
  }
}

/// Interface for managing the state of a form.
abstract class SDUIFormDataProvider {
  Map<String, String> getData();

  void setData(String name, String value);
}

/// Interface for attaching a form with its fields
abstract class SDUIFormField {
  void attachForm(GlobalKey<FormState> formKey, SDUIFormDataProvider provider);
}

class _FormWidgetStateful extends StatefulWidget {
  final SDUIForm delegate;

  const _FormWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormWidgetState(delegate);
}

class _FormWidgetState extends State<_FormWidgetStateful>
    implements SDUIFormDataProvider {
  SDUIForm delegate;
  Map<String, String> data = <String, String>{};
  final key = GlobalKey<FormState>();

  _FormWidgetState(this.delegate);

  @override
  Map<String, String> getData() => data;

  @override
  void setData(String name, String value) {
    data[name] = value;
  }

  @override
  void initState() {
    super.initState();
    delegate.children.forEach((element) {
      if (element is SDUIFormField) {
        (element as SDUIFormField).attachForm(key, this);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: key,
        child: Column(
          children: delegate
              .childrenWidgets(context)
              .map((e) => _decorate(e))
              .toList(),
        ));
  }

  Widget _decorate(Widget widget) => delegate.padding == null
      ? widget
      : Container(padding: EdgeInsets.all(delegate.padding!), child: widget);
}
