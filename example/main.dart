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
    HttpTracingInterceptor("demo")
  ];

  onboarded = (await SharedPreferences.getInstance())
      .getBool(HttpOnboardingInterceptor.HEADER_ONBOARDED);
  runApp(MyApp(baseUrl: 'http://localhost:8080'));
}

class MyApp extends StatelessWidget {
  String baseUrl = '';

  MyApp({Key? key, required this.baseUrl}) : super(key: key);

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
  static const String HEADER_DEVICE_ID = 'X-Device-ID';
  static const String HEADER_TRACE_ID = 'X-Trace-ID';
  static const String HEADER_CLIENT_ID = 'X-Client-ID';

  String clientId = 'unknown';

  HttpTracingInterceptor(this.clientId);

  @override
  void onRequest(RequestTemplate request) async {
    request.headers[HEADER_CLIENT_ID] = clientId;
    request.headers[HEADER_TRACE_ID] = _traceId();
    request.headers[HEADER_DEVICE_ID] = await _deviceId();
  }

  @override
  void onResponse(ResponseTemplate response) {}

  String _traceId() => const Uuid().v1();

  Future<String> _deviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString(HEADER_DEVICE_ID);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v1();
      prefs.setString(HEADER_DEVICE_ID, deviceId);
    }
    return deviceId;
  }
}

/// HTTP interceptor that stored into the share preferences the response header `x-onboarded`,
/// to indicate that the user has been onboarded.
class HttpOnboardingInterceptor extends HttpInterceptor {
  static const String HEADER_ONBOARDED = 'x-onboarded';

  @override
  void onRequest(RequestTemplate request) {}

  @override
  void onResponse(ResponseTemplate response) async {
    if (response.headers[HEADER_ONBOARDED] != null) {
      (await SharedPreferences.getInstance()).setBool(HEADER_ONBOARDED, true);
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
  void onResponse(ResponseTemplate response) async {}

  String _language() =>
      WidgetsBinding.instance?.window.locale.languageCode ?? 'en';
}
