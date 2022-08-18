import 'package:flutter/material.dart';

typedef KeyboardTapCallback = void Function(String text);

class NumericKeyboard extends StatefulWidget {
  /// Color of the text [default = Colors.black]
  final Color textColor;

  /// Display a custom right icon
  final Widget? rightButton;

  /// Font size
  final double fontSize;

  /// Action to trigger when right button is pressed
  final Function()? rightButtonFn;

  /// Display a custom left icon
  final Widget? leftButton;

  /// Action to trigger when left button is pressed
  final Function()? leftButtonFn;

  /// Callback when an item is pressed
  final KeyboardTapCallback onKeyboardTap;

  /// Button Size
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
      this.buttonSize = 70.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _NumericKeyboardState(this);
  }
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  final NumericKeyboard delegate;

  _NumericKeyboardState(this.delegate);

  @override
  Widget build(BuildContext context) => Container(
      alignment: Alignment.center,
      width: 3 * (widget.buttonSize + 10),
      height: 4 * (widget.buttonSize + 10),
      child: GridView.builder(
          itemCount: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            if (index == 9) {
              return _button(999, widget.leftButton, widget.leftButtonFn);
            } else if (index == 10) {
              return _calcButton(0, '0');
            } else if (index == 11) {
              return _button(111, widget.rightButton, widget.rightButtonFn);
            } else {
              return _calcButton((index + 1), (index + 1).toString());
            }
          }));

  Widget _calcButton(int index, String value) => Container(
      width: widget.buttonSize,
      height: widget.buttonSize,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(1),
      child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: TextButton(
              key: delegate.key == null ? null : Key('${delegate.key}_$index'),
              onPressed: () => widget.onKeyboardTap(value),
              child: Text(value,
                  style: TextStyle(
                      color: widget.textColor, fontSize: widget.fontSize)))));

  Widget _button(int index, Widget? button, Function()? callback) {
    Widget? child;
    if (button is Icon) {
      child = IconButton(
          key: delegate.key == null ? null : Key('${delegate.key}_$index'),
          icon:
              Icon(button.icon, size: widget.fontSize, color: widget.textColor),
          onPressed: callback);
    } else if (button is Text) {
      child = TextButton(
        onPressed: callback,
        child: button,
        style: TextButton.styleFrom(primary: widget.textColor),
      );
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
