import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sdui/sdui.dart';

/// Descriptor of [MoneyText]
class SDUIMoneyText extends SDUIWidget {
  double? value;
  String? currency;
  String? color;

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    value = json?['value'];
    currency = json?['currency'];
    color = json?['color'];
    return super.fromJson(json);
  }

  @override
  Widget toWidget(BuildContext context) => MoneyText(
        value: value ?? 0,
        currency: currency ?? 'XAF',
        color: toColor(color) ?? Colors.black,
      );
}

/// Widget to display monetary text
class MoneyText extends StatelessWidget {
  final double value;
  final String currency;
  final String numberFormat;
  final double valueFontSize;
  final double currencyFontSize;
  final Color color;
  final bool bold;

  const MoneyText(
      {Key? key,
      required this.value,
      required this.currency,
      this.numberFormat = '#,###,##0',
      this.valueFontSize = 50,
      this.currencyFontSize = 18,
      this.color = Colors.black,
      this.bold = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Text.rich(TextSpan(
          text: NumberFormat(numberFormat).format(value),
          style: TextStyle(
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: valueFontSize),
          children: [
            WidgetSpan(
              child: Transform.translate(
                offset: Offset(5.0, currencyFontSize - valueFontSize),
                child: Text(
                  currency,
                  style: TextStyle(
                      color: color,
                      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                      fontSize: currencyFontSize),
                ),
              ),
            ),
          ]));
}
