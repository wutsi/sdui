import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';
import 'package:sdui/src/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

bool? onboarded;

void main() async {
  Http.getInstance().interceptors = [
    HttpJsonInterceptor(),
    HttpInternationalizationInterceptor(),
    HttpTracingInterceptor("demo", await _deviceId())
  ];

  onboarded = (await SharedPreferences.getInstance())
      .getBool(HttpOnboardingInterceptor.headerOnboarded);
  runApp(const MyApp(baseUrl: 'http://localhost:8080'));
}

Future<String> _deviceId() async {
  final prefs = await SharedPreferences.getInstance();
  var deviceId = prefs.getString(HttpTracingInterceptor.headerDeviceId);
  if (deviceId == null || deviceId.isEmpty) {
    deviceId = const Uuid().v1();
    prefs.setString(HttpTracingInterceptor.headerDeviceId, deviceId);
  }
  return deviceId;
}

class MyApp extends StatelessWidget {
  final String baseUrl;

  const MyApp({this.baseUrl = '', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Demo',
        initialRoute: onboarded == true ? "/" : "/onboard",
        routes: _routes());
  }

  Map<String, WidgetBuilder> _routes() => {
        '/': (context) => const HomeScreen(),
        '/error': (context) => const ErrorScreen(),
        '/onboard': (context) => DynamicRoute(
            provider:
                HttpRouteContentProvider('$baseUrl/app/onboard/screens/home'))
      };
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: const Center(
          child: Text('HOME PAGE'),
        ),
      );
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('!!! ERROR !!!'),
        ),
      );
}

/// Interceptor that add tracing information into the request headers.
/// The tracing information added are:
/// - `X-Device-ID`: ID of the device
/// - `X-Trace-ID`: ID that represent the interfaction trace
/// - `X-Client-ID`: Identification of the client application
class HttpTracingInterceptor extends HttpInterceptor {
  static const String headerDeviceId = 'X-Device-ID';
  static const String headerTraceId = 'X-Trace-ID';
  static const String headerClientId = 'X-Client-ID';

  String clientId = '';
  String deviceId = '';

  HttpTracingInterceptor(this.clientId, this.deviceId);

  @override
  void onRequest(RequestTemplate request) async {
    request.headers[headerClientId] = clientId;
    request.headers[headerTraceId] = const Uuid().v1();
    request.headers[headerDeviceId] = deviceId;
  }

  @override
  void onResponse(ResponseTemplate response) {}
}

/// HTTP interceptor that stored into the share preferences the response header `x-onboarded`,
/// to indicate that the user has been onboarded.
class HttpOnboardingInterceptor extends HttpInterceptor {
  static const String headerOnboarded = 'x-onboarded';

  @override
  void onRequest(RequestTemplate request) {}

  @override
  void onResponse(ResponseTemplate response) async {
    if (response.headers[headerOnboarded] != null) {
      (await SharedPreferences.getInstance()).setBool(headerOnboarded, true);
    }
  }
}

/// HTTP interceptor that set the request header `Accept-Language` to the current user language
class HttpInternationalizationInterceptor extends HttpInterceptor {
  @override
  void onRequest(RequestTemplate request) {
    request.headers['Accept-Language'] = _language();
  }

  @override
  void onResponse(ResponseTemplate response) {}

  String _language() =>
      WidgetsBinding.instance?.window.locale.languageCode ?? 'en';
}
