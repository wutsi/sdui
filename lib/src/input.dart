import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logger/logger.dart';
import 'package:sdui/sdui.dart';
import 'package:sdui/src/logger.dart';

import 'button.dart';
import 'form.dart';
import 'widget.dart';

/// Descriptor of a form Input
///
/// ### JSON Attributes
/// - **name**: REQUIRED. This should be the name of the input field
/// - **type**: Type of input field. The possible values are:
///    - `text`: Free text (Default)
///    - `url`
///    - `email`
///    - `number`
///    - `phone`: Phone number
///    - `date`: Date
///    - `time`: Time
/// - **value**: Default value.
///    - When `type=date`, the format should be `yyyy-MM-dd` (Ex: 2020-07-30)
///    - When `type=time`, the format should be `HH:mm` (Ex: 23:30)
///    - When `type=phone`, the format should be in E.164 format (Ex: +442087712924)
/// - **hideText**: if `true`, the input text will be hide. (Default: `false`)
/// - **caption**: Title of the input
/// - **hint**: Help test for users
/// - **required**: if `true`, validation will be fired to ensure that the field has a value
/// - **readOnly**: if `true`, the field will not be editable (Default: `false`)
/// - **maxLength**: Maximum length of the field
/// - **maxLine**: Maximum number of line  (for multi-line input)
/// - **minLength**: Minimum length of the field (Default: 0)
/// - **countries**: List of country codes - for `type=phone`
/// - *action***: [SDUIAction] to execute when the input is clicked
class SDUIInput extends SDUIWidget with SDUIFormField {
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
  List<String>? countries;

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

    var nodes = json?["countries"];
    if (nodes is List<dynamic>) {
      countries = nodes.map((e) => e.toString()).toList();
    }
    return super.fromJson(json);
  }

  Widget _createWidget(BuildContext context) {
    switch (type.toLowerCase()) {
      case 'submit':
        return _SubmitWidgetStateful(this);

      case 'date':
      case 'time':
        return _DateTimeWidgetStateful(this);

      case 'phone':
        return _PhoneWidgetStateful(this);

      default:
        return _TextFieldWidgetStateful(this);
    }
  }

  String? _onValidate(String? value) {
    bool empty = (value == null || value.isEmpty);
    if (required && empty) {
      return "This field is required";
    }
    if (minLength > 0 && (empty || value.length < minLength)) {
      return "This field must have at least $minLength characters";
    }
    if (type == 'email' && !empty && !EmailValidator.validate(value)) {
      return "Malformed email address";
    }
    if (type == 'url' && !empty) {
      try {
        Uri.parse(value);
      } catch (e) {
        return "Malformed URL address";
      }
    }
    if (type == 'number' && !empty) {
      if (double.tryParse(value) == null) {
        return "Invalid number";
      }
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

/// Text
class _TextFieldWidgetStateful extends StatefulWidget {
  final SDUIInput delegate;

  const _TextFieldWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _TextFieldWidgetState(delegate);
}

class _TextFieldWidgetState extends State<_TextFieldWidgetStateful> {
  SDUIInput delegate;
  String state = '';

  _TextFieldWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();
    state = delegate.value ?? '';
    delegate.provider?.setData(delegate.name, state);
  }

  @override
  Widget build(BuildContext context) => TextFormField(
      enabled: delegate.enabled,
      decoration: _toInputDecoration(),
      controller: TextEditingController(text: state),
      obscureText: delegate.hideText,
      readOnly: delegate.readOnly,
      maxLength: delegate.maxLength,
      maxLines: delegate.maxLines,
      keyboardType: _toKeyboardType(),
      onChanged: (String value) => _onChanged(value),
      validator: (String? value) => _onValidate(value));

  TextInputType? _toKeyboardType() {
    switch (delegate.type.toLowerCase()) {
      case 'email':
        return TextInputType.emailAddress;
      case 'number':
        return TextInputType.number;
      case 'url':
        return TextInputType.url;
    }
    return TextInputType.text;
  }

  InputDecoration? _toInputDecoration() => InputDecoration(
      hintText: delegate.hint,
      label: delegate.caption == null ? null : Text(delegate.caption!));

  String? _onValidate(String? value) => delegate._onValidate(value);

  void _onChanged(String value) {
    delegate.provider?.setData(delegate.name, value);
  }
}

/// Submit
class _SubmitWidgetStateful extends StatefulWidget {
  final SDUIInput delegate;

  const _SubmitWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _SubmitWidgetState(delegate);
}

class _SubmitWidgetState extends State<_SubmitWidgetStateful> {
  bool busy = false;
  SDUIInput delegate;
  SDUIButton button = SDUIButton();

  _SubmitWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();

    button = SDUIButton(
        caption: delegate.caption,
        onPressed: (context) => delegate._onSubmit(context));
    button.action.pageController = delegate.action.pageController;
  }

  @override
  Widget build(BuildContext context) => button.toWidget(context);
}

/// Date Time
class _DateTimeWidgetStateful extends StatefulWidget {
  final SDUIInput delegate;

  const _DateTimeWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _DateTimeWidgetState(delegate);
}

class _DateTimeWidgetState extends State<_DateTimeWidgetStateful> {
  static final Logger _logger = LoggerFactory.create('_DateTimeWidgetState');

  DateTime state = DateTime.now();
  DateFormat displayDateFormat = DateFormat("yyyy-MM-dd");
  DateFormat dataDateFormat = DateFormat("yyyy-MM-dd");
  SDUIInput delegate;

  _DateTimeWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();

    if (delegate.type == 'date') {
      displayDateFormat = DateFormat("dd MMM yyyy");
      dataDateFormat = DateFormat("yyyy-MM-dd");
    } else {
      displayDateFormat = DateFormat("HH:mm");
      dataDateFormat = DateFormat("HH:mm");
    }

    if (delegate.value == null || delegate.value?.isEmpty == true) {
      state = DateTime.now();
    } else {
      try {
        state = dataDateFormat.parse(delegate.value!);
      } catch (e) {
        _logger.w("Invalid date: ${delegate.value}");
      }
    }
    delegate.provider?.setData(delegate.name, _text());
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(delegate.caption ?? '',
                style: const TextStyle(color: Color(0xff707070), fontSize: 12)),
          ),
          SizedBox(
              width: double.infinity,
              child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xff909090))),
                  ),
                  child: TextButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    child: Text(
                      _displayText(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () => _selectDateOrTime(context),
                  )))
        ],
      ));

  String _text() => dataDateFormat.format(state);

  String _displayText() => displayDateFormat.format(state);

  void _selectDateOrTime(BuildContext context) async {
    if (delegate.type == 'date') {
      _selectDate(context);
    } else if (delegate.type == 'time') {
      _selectTime(context);
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 100),
    );

    if (picked != null && picked != state) {
      setState(() {
        state = picked;
        delegate.provider?.setData(delegate.name, _text());
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: state.hour, minute: state.minute));

    if (picked != null) {
      setState(() {
        state = DateTime(
            state.year, state.month, state.day, picked.hour, picked.minute);
        delegate.provider?.setData(delegate.name, _text());
      });
    }
  }
}

/// Phone
class _PhoneWidgetStateful extends StatefulWidget {
  final SDUIInput delegate;

  const _PhoneWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _PhoneWidgetState(delegate);
}

class _PhoneWidgetState extends State<_PhoneWidgetStateful> {
  String state = '';
  SDUIInput delegate;

  _PhoneWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();

    delegate.provider?.setData(delegate.name, delegate.value ?? '');
    state = delegate.value ?? '';
  }

  @override
  Widget build(BuildContext context) => InternationalPhoneNumberInput(
        selectorConfig:
            const SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG),
        ignoreBlank: true,
        formatInput: false,
        isEnabled: delegate.enabled,
        countries: delegate.countries,
        textFieldController: TextEditingController(text: state),
        hintText: delegate.caption,
        onInputChanged: (v) => _onChanged(v),
        validator: (s) => _onValidate(s),
      );

  void _onChanged(PhoneNumber value) {
    delegate.provider?.setData(delegate.name, value.phoneNumber ?? '');
  }

  String? _onValidate(String? value) {
    return delegate._onValidate(value);
  }
}
