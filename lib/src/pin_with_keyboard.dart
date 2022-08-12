import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'action.dart';
import 'form.dart';
import 'loading.dart';
import 'numeric_keyboard.dart';
import 'widget.dart';

/// Descriptor of a [PinCodeTextField] with a [NumericKeyboard]
///
/// ### JSON Attributes
/// - **name**: Name of the field. (default: `value`)
/// - **color**: Text color (default: black)
/// - **hideText**: Hide the text (default: false)
/// - **maxLength**: Max length of the code to enter (default: 6)
/// - **pinSize**: Size of each pin input (default=20)
/// - **keyboardButtonSize**: Size of each keyboard button (default=70)
class SDUIPinWidthKeyboard extends SDUIWidget with SDUIFormField {
  String name = 'value';
  Color color = Colors.black;
  bool hideText = false;
  int maxLength = 6;
  double pinSize = 30.0;
  double keyboardButtonSize = 70.0;

  @override
  Widget toWidget(BuildContext context) => _PinWithKeyboard(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"] ?? 'value';
    color = toColor(json?["color"]) ?? Colors.black;
    hideText = json?["hideText"] ?? false;
    maxLength = json?["maxLength"] ?? 6;
    pinSize = json?['pinSize'] ?? 10.0;
    keyboardButtonSize = json?['keyboardButtonSize'] ?? 70.0;
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
            child: Pinput(
              controller: controller,
              showCursor: false,
              obscureText: delegate.hideText,
              length: delegate.maxLength,
              submittedPinTheme: delegate.hideText
                  ? PinTheme(
                      width: delegate.pinSize,
                      height: delegate.pinSize,
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: delegate.pinSize,
                          textBaseline: TextBaseline.alphabetic,
                          color: delegate.color),
                      decoration: BoxDecoration(
                        border: Border.all(color: delegate.color),
                        color: delegate.color,
                        borderRadius: BorderRadius.circular(5.0),
                      ))
                  : null,
              defaultPinTheme: PinTheme(
                width: delegate.pinSize,
                height: delegate.pinSize,
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: delegate.pinSize,
                    textBaseline: TextBaseline.alphabetic,
                    color: delegate.color),
                decoration: BoxDecoration(
                  border: Border.all(color: delegate.color),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: buzy
                ? Center(child: sduiProgressIndicator(context))
                : NumericKeyboard(
                    textColor: delegate.color,
                    buttonSize: delegate.keyboardButtonSize,
                    onKeyboardTap: (value) => _onKeyboardTap(context, value),
                    rightButtonFn: () => _onBack(context),
                    rightButton: Icon(Icons.backspace, color: delegate.color),
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
