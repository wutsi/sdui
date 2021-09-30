import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'route.dart';

/// Descriptor of a widget behavior.
/// This class can be used to:
/// - Handle the screen navigation
/// - Execute commands
class SDUIAction {
  static final Logger _logger = Logger(
    printer: LogfmtPrinter(),
  );

  /// Type of action.
  ///
  /// The supported values:
  /// - `screen`: To redirect to another screen
  /// - `command`: To execute a command on the server
  String type = '';

  /// Action URL.
  ///
  /// - ``route:/..``: redirects users to previous route
  /// - URL starting with ``route:/<ROUTE_NAME>`` redirect user the a named route. (Ex: ``route:/checkout``)
  /// - URL starting with ``http://`` or ``https`` redirect user to a server driven page
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
      var route = url.substring(6);
      if (route == '/..') {
        Navigator.pop(context);
      } else {
        Navigator.pushNamed(context, route);
      }
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
