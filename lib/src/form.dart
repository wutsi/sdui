import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

abstract class SDUIFormField {
  void attach(GlobalKey<FormState> formKey, SDUIFormDataProvider provider);
}

abstract class SDUIFormDataProvider {
  Map<String, String> getData();
}

class FormFieldKey extends ValueKey<String> {
  const FormFieldKey(String value) : super(value);

  @override
  String toString() => value;
}

class SDUIForm extends SDUIComposite {
  double? padding;

  @override
  Widget toWidget(BuildContext context) => FormWidgetStateful(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    padding = json?["padding"];
    return this;
  }
}

class FormWidgetStateful extends StatefulWidget {
  final SDUIForm delegate;

  const FormWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FormWidgetState(delegate);
}

class FormWidgetState extends State<FormWidgetStateful>
    implements SDUIFormDataProvider {
  SDUIForm delegate;
  List<Widget> widgets = <Widget>[];
  final key = GlobalKey<FormState>();

  FormWidgetState(this.delegate);

  @override
  Map<String, String> getData() {
    var data = <String, String>{};
    int i = 0;
    widgets.forEach((element) {
      i++;
      String name = element.key?.toString() ?? '_key_$i';
      if (element is TextFormField) {
        data[name] = element.controller?.text ?? '';
      }
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    delegate.children.forEach((element) {
      if (element is SDUIFormField) {
        (element as SDUIFormField).attach(key, this);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    widgets = delegate.childrenWidgets(context);
    return Form(
        key: key,
        child: Column(
          children: widgets.map((e) => _decorate(e)).toList(),
        ));
  }

  Widget _decorate(Widget widget) => delegate.padding == null
      ? widget
      : Container(padding: EdgeInsets.all(delegate.padding!), child: widget);
}
