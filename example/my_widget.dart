import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

/// This is an example of custom widget
class MyWidget extends SDUIWidget {
  String text = '';
  double padding = 10.0;
  double margin = 10.0;

  /// This method will be called by [SDUIParser] to read the widget attributes from the JSON data
  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    text = json?['caption'] ?? '';
    margin = json?['margin'] ?? 10.0;
    padding = json?['padding'] ?? 10.0;
    return this;
  }

  /// This method will be called when rendering the page to create the Flutter widget
  @override
  Widget toWidget(BuildContext context) => Container(
        padding: EdgeInsets.all(padding),
        margin: EdgeInsets.all(margin),
        child: Text(
          text,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
}
