import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'route.dart';

class SDUIAction {
  static final Logger _logger = Logger(
    printer: LogfmtPrinter(),
  );

  String type = '';
  String url = '';

  SDUIAction fromJson(Map<String, dynamic>? attributes) {
    url = attributes?["url"] ?? '';
    type = attributes?["type"] ?? '';
    return this;
  }

  Future<String> execute(
      BuildContext context, Map<String, dynamic>? data) async {
    switch (type.toLowerCase()) {
      case 'screen':
        return _navigate(context, data);
      case 'command':
        return _command(context, data);
      default:
        return Future(() => "{}");
    }
  }

  Future<String> _navigate(BuildContext context, Map<String, dynamic>? data) {
    if (_isRoute()) {
      _logger.i('Navigating to route to $url');
      Navigator.pushNamed(context, url.substring(6));
    } else if (_isNetwork()) {
      _logger.i('Navigating to screen $url');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DynamicRoute(provider: HttpRouteContentProvider(url))),
      );
    }
    return Future(() => "{}");
  }

  Future<String> _command(
      BuildContext context, Map<String, dynamic>? data) async {
    _logger.i('Executing Command $url $data');
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('FAILED: $url - ${response.statusCode}');
    }
  }

  bool _isRoute() => url.startsWith('route:') == true;

  bool _isNetwork() => url.startsWith('http://') || url.startsWith('https://');
}
