import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sdui/sdui.dart';

import 'form.dart';
import 'numeric_keyboard.dart';
import 'widget.dart';

/// Descriptor of a [PinCodeTextField] with a [NumericKeyboard]
///
/// ### JSON Attributes
/// - **name**: Name of the field. (default: `value`)
/// - **color**: Text color (default: black)
/// - **hideText**: Hide the text (default: false)
/// - **maxLength**: Max length of the code to enter (default: 6)
/// - **deleteText**: Text of delete button (default: 'Delete')
/// - **pinSize**: Size of each pin input (default=20)
/// - **keyboardButtonSize**: Size of each keyboard button (default=90)
class SDUIPinWidthKeyboard extends SDUIWidget with SDUIFormField {
  String name = 'value';
  Color color = Colors.black;
  bool hideText = false;
  int maxLength = 6;
  String deleteText = 'Delete';
  double pinSize = 20.0;
  double keyboardButtonSize = 90.0;

  @override
  Widget toWidget(BuildContext context) => _PinWithKeyboard(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"] ?? 'value';
    color = toColor(json?["color"]) ?? Colors.black;
    hideText = json?["hideText"] ?? false;
    maxLength = json?["maxLength"] ?? 6;
    deleteText = json?['deleteText'] ?? 'Delete';
    pinSize = json?['pinSize'] ?? 20.0;
    keyboardButtonSize = json?['keyboardButtonSize'] ?? 90.0;
    return this;
  }
}

class _PinWithKeyboard extends StatefulWidget {
  final SDUIPinWidthKeyboard delegate;

  const _PinWithKeyboard(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _PinWithKeyboardState createState() => _PinWithKeyboardState(delegate);
}

class _PinWithKeyboardState extends State<_PinWithKeyboard> {
  SDUIPinWidthKeyboard delegate;
  bool buzy = false;
  TextEditingController controller = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: delegate.color),
      borderRadius: BorderRadius.circular(20.0),
    );
  }

  _PinWithKeyboardState(this.delegate);

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.center,
            width: (delegate.pinSize + 20) * delegate.maxLength,
            padding: const EdgeInsets.all(10),
            child: PinPut(
              fieldsCount: delegate.maxLength,
              controller: controller,
              separator: const SizedBox(width: 5.0),
              keyboardType: TextInputType.none,
              eachFieldConstraints:
                  const BoxConstraints(minHeight: 10.0, minWidth: 10.0),
              eachFieldWidth: delegate.pinSize,
              eachFieldPadding: const EdgeInsets.all(2),
              eachFieldMargin: const EdgeInsets.all(2),
              submittedFieldDecoration: _pinPutDecoration,
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration,
              obscureText: delegate.hideText ? '●' : null,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: buzy
                ? SizedBox(
                    width: 13,
                    height: 13,
                    child: CircularProgressIndicator(
                      color: delegate.color,
                      strokeWidth: 2,
                    ))
                : NumericKeyboard(
                    textColor: delegate.color,
                    onKeyboardTap: (value) => _onKeyboardTap(context, value),
                    rightButtonFn: () => _onBack(context),
                    rightButton: Text(delegate.deleteText),
                  ),
          ),
        ],
      );

  void _onKeyboardTap(BuildContext context, String value) {
    String text = controller.text;
    if (text.length < delegate.maxLength) {
      _changeText(context, text + value);
    }
  }

  void _onBack(BuildContext context) {
    String text = controller.text;
    if (text.isNotEmpty) {
      _changeText(context, text.substring(0, text.length - 1));
    }
  }

  void _changeText(BuildContext context, String value) {
    setState(() {
      buzy = (value.length == delegate.maxLength);
      controller.text = value;
    });
    delegate.provider?.setData(delegate.name, value);

    if (buzy) {
      delegate.action
          .execute(context, {delegate.name: value})
          .then((value) => _handleResult(value))
          .whenComplete(() => _onComplete());
    }
  }

  Future<String?> _handleResult(String? result) async {
    if (result == null) {
      return Future.value(null);
    }

    var json = jsonDecode(result);
    if (json is Map<String, dynamic>) {
      var action = SDUIAction().fromJson(json);
      action.pageController = delegate.action.pageController;
      return action
          .execute(context, json)
          .then((value) => _handleResult(value));
    }
    return Future.value(null);
  }

  void _onComplete() {
    setState(() {
      buzy = false;
      controller.text = '';
    });
  }
}
