import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'numeric_keyboard.dart';
import 'widget.dart';

/// Descriptor of a [PinCodeTextField] with a [NumericKeyboard]
///
/// ### JSON Attributes
/// - **name**: Name of the field. (default: `value`)
/// - **color**: Text color (default: black)
/// - **hidText**: Hide the text (default: false)
class SDUIPinWidthKeyboard extends SDUIWidget {
  String name = 'value';
  Color color = Colors.black;
  bool hideText = false;

  @override
  Widget toWidget(BuildContext context) => _PinWidthKeyboard(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"] ?? 'value';
    color = toColor(json?["color"]) ?? Colors.black;
    hideText = json?["hideText"];
    return this;
  }
}

class _PinWidthKeyboard extends StatefulWidget {
  final SDUIPinWidthKeyboard delegate;

  const _PinWidthKeyboard(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _PinWithKeyboardState createState() => _PinWithKeyboardState(delegate);
}

class _PinWithKeyboardState extends State<_PinWidthKeyboard> {
  SDUIPinWidthKeyboard delegate;
  String text = '';
  TextEditingController controller = TextEditingController();

  _PinWithKeyboardState(this.delegate);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.center,
            child: PinCodeTextField(
              controller: controller,
              maxLength: 6,
              pinBoxWidth: 40,
              pinBoxHeight: 40,
              pinBoxBorderWidth: 1.0,
              pinBoxRadius: 20,
              pinBoxOuterPadding: const EdgeInsets.all(4.0),
              hideCharacter: delegate.hideText,
              onDone: (value) =>
                  delegate.action.execute(context, {delegate.name: value}),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.bottomCenter,
            child: NumericKeyboard(
              textColor: delegate.color,
              onKeyboardTap: _onKeyboardTap,
              rightButtonFn: () => _onBack(),
              rightButton: const Text('Delete'),
            ),
          ),
        ],
      );

  void _onKeyboardTap(String value) {
    _changeText(text + value);
  }

  void _onBack() {
    _changeText(text.substring(0, text.length - 1));
  }

  void _changeText(String value) {
    setState(() {
      text = value;
      controller.text = value;
    });
  }
}
