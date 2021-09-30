import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'action.dart';
import 'form.dart';
import 'widget.dart';

/// Descriptor of a form Input
class SDUInput extends SDUIWidget implements SDUIFormField {
  String name = '_no_name_';
  String? value;
  bool hideText = false;
  bool required = false;
  String? caption;
  String? hint;
  bool enabled = true;
  bool readOnly = false;
  String type = "text";
  int? maxLines;
  int? maxLength;
  int minLength = 0;
  GlobalKey<FormState>? formKey;
  SDUIFormDataProvider? provider;

  @override
  void attach(GlobalKey<FormState> formKey, SDUIFormDataProvider provider) {
    this.formKey = formKey;
    this.provider = provider;
  }

  @override
  Widget toWidget(BuildContext context) => _createWidget(context);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"] ?? '_no_name_';
    value = json?["value"];
    hideText = json?["hideText"] ?? false;
    required = json?["required"] ?? false;
    caption = json?["caption"];
    hint = json?["hint"];
    enabled = json?["enabled"] ?? true;
    readOnly = json?["readOnly"] ?? false;
    type = json?["type"] ?? "text";
    maxLines = json?["maxLines"];
    maxLength = json?["maxLength"];
    minLength = json?["minLength"] ?? 0;
    return this;
  }

  Widget _createWidget(BuildContext context) {
    switch (type.toLowerCase()) {
      case 'submit':
        return SubmitWidgetStateful(this);

      default:
        return TextFormField(
            key: FormFieldKey(name),
            enabled: enabled,
            decoration: _toInputDecoration(),
            controller: TextEditingController(text: value),
            obscureText: hideText,
            readOnly: readOnly,
            maxLength: maxLength,
            maxLines: maxLines,
            validator: (String? value) => _onValidate(value));
    }
  }

  InputDecoration? _toInputDecoration() => InputDecoration(
      hintText: hint, label: caption == null ? null : Text(caption!));

  String? _onValidate(String? value) {
    if (required && (value == null || value.isEmpty)) {
      return "This field is required";
    }
    if (value!.length < minLength) {
      return "This field must have at least $minLength characters";
    }
    return null;
  }

  Future<String?> _onSubmit(BuildContext context) {
    if (formKey?.currentState?.validate() == false) {
      return Future.value(null);
    }
    return action.execute(context, provider?.getData());
  }
}

class SubmitWidgetStateful extends StatefulWidget {
  final SDUInput delegate;

  const SubmitWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SubmitWidgetState(delegate);
}

class SubmitWidgetState extends State<SubmitWidgetStateful> {
  static final Logger _logger = Logger(
    printer: LogfmtPrinter(),
  );

  bool enabled = false;
  SDUInput delegate;

  SubmitWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();
    enabled = delegate.enabled;
  }

  @override
  Widget build(BuildContext context) => ElevatedButton(
      child: Text(delegate.caption ?? "Submit"),
      onPressed: () => _onSubmit(context));

  void _onSubmit(BuildContext context) {
    if (!enabled) {
      return;
    }

    _disable();
    delegate
        ._onSubmit(context)
        .then((value) => _handleResult(value))
        .onError((error, stackTrace) => _handleError(error, stackTrace))
        .whenComplete(() => _enable());
  }

  void _handleResult(String? result) {
    if (result == null) {
      return;
    }

    var json = jsonDecode(result);
    if (json is Map<String, dynamic>) {
      SDUIAction().fromJson(json).execute(context, json);
    }
  }

  void _handleError(error, stackTrace) {
    _logger.e(error, stackTrace);
  }

  void _enable() {
    setState(() {
      enabled = true;
    });
  }

  void _disable() {
    setState(() {
      enabled = false;
    });
  }
}
