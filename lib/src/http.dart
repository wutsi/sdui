import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Http {
  static const String _HEADER_DEVICE_ID = 'X-Device-ID';
  static const String _HEADER_TRACE_ID = 'X-Trace-ID';
  static const String _HEADER_CLIENT_ID = 'X-Client-ID';
  static final Http _singleton = Http._internal();

  String clientId = 'unknown-client';

  Http._internal();

  factory Http() {
    return _singleton;
  }

  static Http getInstance() => _singleton;

  Future<String> post(String url, Map<String, dynamic>? data) async {
    var response = await http.post(Uri.parse(url),
        body: data == null ? '{}' : jsonEncode(data),
        headers: await _headers());
    if (response.statusCode / 100 == 2) {
      return response.body;
    } else {
      throw Exception('FAILED: $url - ${response.statusCode}');
    }
  }

  Future<Map<String, String>> _headers() async => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': _language(),
        _HEADER_TRACE_ID: _traceId(),
        _HEADER_DEVICE_ID: await _deviceId(),
        _HEADER_CLIENT_ID: clientId
      };

  String _language() =>
      WidgetsBinding.instance?.window.locale.languageCode ?? 'en';

  String _traceId() => const Uuid().v1();

  Future<String> _deviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString(_HEADER_TRACE_ID);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v1();
      prefs.setString(_HEADER_TRACE_ID, deviceId);
    }
    return deviceId;
  }
}
