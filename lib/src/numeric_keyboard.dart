import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef KeyboardTapCallback = void Function(String text);

class NumericKeyboard extends StatefulWidget {
  /// Color of the text [default = Colors.black]
  final Color textColor;

  /// Display a custom right icon
  final Widget? rightButton;

  /// Height of the button
  final double fontSize;

  /// Action to trigger when right button is pressed
  final Function()? rightButtonFn;

  /// Display a custom left icon
  final Widget? leftButton;

  /// Action to trigger when left button is pressed
  final Function()? leftButtonFn;

  /// Callback when an item is pressed
  final KeyboardTapCallback onKeyboardTap;

  // Button width
  final double buttonSize;

  const NumericKeyboard(
      {Key? key,
      required this.onKeyboardTap,
      this.textColor = Colors.black,
      this.fontSize = 40,
      this.rightButtonFn,
      this.rightButton,
      this.leftButtonFn,
      this.leftButton,
      this.buttonSize = 90.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NumericKeyboardState();
  }
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _calcButton('1'),
              _calcButton('2'),
              _calcButton('3'),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _calcButton('4'),
              _calcButton('5'),
              _calcButton('6'),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _calcButton('7'),
              _calcButton('8'),
              _calcButton('9'),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _button(widget.leftButton, widget.leftButtonFn),
              _calcButton('0'),
              _button(widget.rightButton, widget.rightButtonFn),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcButton(String value) => Container(
      width: widget.buttonSize,
      height: widget.buttonSize,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(1),
      child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: TextButton(
              onPressed: () => widget.onKeyboardTap(value),
              child: Text(value,
                  style: TextStyle(
                      color: widget.textColor, fontSize: widget.fontSize)))));

  Widget _button(Widget? button, Function()? callback) {
    Widget? child;
    if (button is Icon) {
      child = IconButton(
          icon:
              Icon(button.icon, size: widget.fontSize, color: widget.textColor),
          onPressed: callback);
    } else if (button is Text) {
      child = TextButton(onPressed: callback, child: button);
    }

    return Container(
        width: widget.buttonSize,
        height: widget.buttonSize,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(1),
        child: SizedBox(
            width: double.infinity, height: double.infinity, child: child));
  }
}
