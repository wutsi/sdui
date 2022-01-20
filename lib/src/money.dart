import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'form.dart';
import 'numeric_keyboard.dart';
import 'route.dart';
import 'widget.dart';

/// Descriptor of [MoneyText]
///
/// ###: Attributes
/// - **value**: Current value
/// - **currency**: Currency code
/// - **color**: Text color
/// - **numberFormat**: Number format of the money to display
class SDUIMoneyText extends SDUIWidget {
  double? value;
  String? currency;
  String? color;
  String? numberFormat;

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    value = json?['value'];
    currency = json?['currency'];
    color = json?['color'];
    numberFormat = json?['numberFormat'];
    return super.fromJson(json);
  }

  @override
  Widget toWidget(BuildContext context) => MoneyText(
        value: value ?? 0,
        currency: currency ?? 'XAF',
        color: toColor(color),
        numberFormat: numberFormat,
      );
}

/// Widget to display monetary text
class MoneyText extends StatelessWidget {
  final double value;
  final String currency;
  final String? numberFormat;
  final double valueFontSize;
  final double currencyFontSize;
  final Color? color;
  final bool? bold;

  const MoneyText(
      {Key? key,
      required this.value,
      required this.currency,
      this.numberFormat,
      this.valueFontSize = 50,
      this.currencyFontSize = 12,
      this.color,
      this.bold = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Text.rich(TextSpan(
          text: numberFormat == null
              ? value.toString()
              : NumberFormat(numberFormat).format(value),
          style: TextStyle(
              color: color,
              fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
              fontSize: valueFontSize),
          children: [
            WidgetSpan(
              child: Transform.translate(
                offset: Offset(5.0, currencyFontSize - valueFontSize),
                child: Text(
                  currency,
                  style: TextStyle(
                      color: color,
                      fontWeight:
                          bold == true ? FontWeight.bold : FontWeight.normal,
                      fontSize: currencyFontSize),
                ),
              ),
            ),
          ]));
}

/// Descriptor of [MoneyText] with [NumericKeyboard]
///
/// ###: Attributes
/// - **name**: Name of the field
/// - **value**: Current value
/// - **currency**: Currency code
/// - **moneyColor**: Text color of the money
/// - **keyboardColor**: Text color of the keyboard
///  - **numberFormat**: Number format of the money to display
///  - **maxLength**: Maximum length of the moneytary value (default: 7)
///  - **keyboardButtonSize**: Size of the keyboard button
class SDUIMoneyWithKeyboard extends SDUIWidget with SDUIFormField {
  String name = 'value';
  int? value;
  String? currency;
  String? moneyColor;
  String? keyboardColor;
  String? numberFormat;
  int maxLength = 7;
  double keyboardButtonSize = 70.0;

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?['name'] ?? 'name';
    currency = json?['currency'];
    moneyColor = json?['moneyColor'];
    keyboardColor = json?['keyboardColor'];
    value = json?['value'];
    maxLength = json?['maxLength'] ?? 7;
    keyboardButtonSize = json?['keyboardButtonSize'] ?? 70.0;
    numberFormat = json?['numberFormat'];

    return this;
  }

  @override
  Widget toWidget(BuildContext context) => _MoneyWithKeyboard(this);
}

class _MoneyWithKeyboard extends StatefulWidget {
  final SDUIMoneyWithKeyboard delegate;

  const _MoneyWithKeyboard(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _MoneyWithKeyboardState createState() => _MoneyWithKeyboardState(delegate);
}

class _MoneyWithKeyboardState extends State<_MoneyWithKeyboard>
    with RouteAware {
  SDUIMoneyWithKeyboard delegate;
  int state = 0;

  _MoneyWithKeyboardState(this.delegate);

  @override
  void initState() {
    super.initState();

    state = delegate.value ?? 0;
    delegate.provider?.setData(delegate.name, state.toString());

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      sduiRouteObserver.subscribe(this, ModalRoute.of(context)!);
    });
  }

  @override
  void dispose() {
    super.dispose();

    sduiRouteObserver.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.center,
            child: MoneyText(
              color: delegate.toColor(delegate.moneyColor),
              value: state.toDouble(),
              currency: delegate.currency ?? 'XAF',
              numberFormat: delegate.numberFormat,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: NumericKeyboard(
              buttonSize: delegate.keyboardButtonSize,
              textColor: _keyboardColor(),
              onKeyboardTap: (value) => _onKeyboardTap(value),
              rightButtonFn: () => _onBack(),
              rightButton: Icon(Icons.backspace, color: _keyboardColor()),
            ),
          ),
        ],
      );

  Color _keyboardColor() =>
      delegate.toColor(delegate.keyboardColor) ?? Colors.black;

  void _onKeyboardTap(String value) {
    _changeText(state * 10 + int.parse(value));
  }

  void _onBack() {
    int value = (state ~/ 10).toInt();
    _changeText(value);
  }

  void _changeText(int value) {
    if (value.toString().length <= delegate.maxLength) {
      setState(() {
        state = value;
      });
    }
    delegate.provider?.setData(delegate.name, state.toString());
  }

  @override
  void didPopNext() {
    super.didPopNext();

    // Force refresh of the page
    setState(() {
      state = 0;
      delegate.provider?.setData(delegate.name, state.toString());
    });
  }
}

/// Descriptor of [MoneyText] with [Slider]
///
/// ###: Attributes
/// - **name**: Name of the field
/// - **value**: Current value
/// - **currency**: Currency code
/// - **moneyColor**: Text color of the money
/// - **sliderColor**: Color of the slider
///  - **numberFormat**: Number format of the money to display
///  - **maxLength**: Maximum length of the moneytary value (default: 7)
///  - **maxValue**: Slider max value
class SDUIMoneyWithSlider extends SDUIWidget with SDUIFormField {
  String name = 'value';
  int? value;
  String? currency;
  String? moneyColor;
  String? sliderColor;
  String? numberFormat;
  int maxLength = 7;
  int? maxValue;

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?['name'] ?? 'name';
    currency = json?['currency'];
    moneyColor = json?['moneyColor'];
    sliderColor = json?['sliderColor'];
    value = json?['value'];
    maxLength = json?['maxLength'] ?? 7;
    numberFormat = json?['numberFormat'];
    maxValue = json?['maxValue'];

    return this;
  }

  @override
  Widget toWidget(BuildContext context) => _MoneyWithSlider(this);
}

class _MoneyWithSlider extends StatefulWidget {
  final SDUIMoneyWithSlider delegate;

  const _MoneyWithSlider(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _MoneyWithSliderState(delegate);
}

class _MoneyWithSliderState extends State<_MoneyWithSlider> {
  SDUIMoneyWithSlider delegate;
  double state = 0;

  _MoneyWithSliderState(this.delegate);

  @override
  void initState() {
    super.initState();

    state = delegate.value?.toDouble() ?? 0.0;
    delegate.provider?.setData(delegate.name, state.toString());
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: MoneyText(
              color: delegate.toColor(delegate.moneyColor),
              value: state.toDouble(),
              currency: delegate.currency ?? 'XAF',
              numberFormat: delegate.numberFormat,
            ),
          ),
          Slider(
            value: state,
            min: 0,
            max: delegate.maxValue?.toDouble() ?? 100000,
            onChanged: (value) => _changed(value),
            activeColor: delegate.toColor(delegate.sliderColor),
          ),
        ],
      );

  void _changed(double value) {
    setState(() => {state = value});
    delegate.provider?.setData(delegate.name, state.toString());
  }
}
