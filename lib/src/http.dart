import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class RequestTemplate {
  Map<String, String> headers = <String, String>{};
  String method;
  String url = '';
  Object? body;
  Encoding? encoding;

  RequestTemplate(this.url, {this.method = '', this.body, this.encoding});
}

class ResponseTemplate {
  RequestTemplate? request;
  Map<String, String> headers = <String, String>{};
  String body;
  int statusCode = 200;

  ResponseTemplate({this.request, this.body = '', this.statusCode = 200});
}

/// HttpRequestInterceptor is invoked for each HTTP request.
abstract class HttpInterceptor {
  void onRequest(RequestTemplate request);

  void onResponse(ResponseTemplate response);
}

class HttpJsonInterceptor extends HttpInterceptor {
  @override
  void onRequest(RequestTemplate request) {
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';

    request.body = request.body is Map<String, dynamic>?
        ? jsonEncode(request.body)
        : request.body;
  }

  @override
  void onResponse(ResponseTemplate response) {}
}

/// HttpRequestResponse is invoked for each HTTP response.
abstract class HttpRequestResponse {
  void apply(http.Response response);
}

class Http {
  static final Http _singleton = Http._internal();

  List<HttpInterceptor> interceptors = [HttpJsonInterceptor()];
  final Logger _logger = Logger();

  Http._internal();

  factory Http() {
    return _singleton;
  }

  static Http getInstance() => _singleton;

  Future<String> post(String url, Map<String, dynamic>? data) async {
    var request = _pre('POST', url, data);
    var response = _post(
        request,
        await http.post(Uri.parse(request.url),
            body: request.body, headers: request.headers));

    if (response.statusCode / 100 == 2) {
      return response.body;
    } else {
      throw http.ClientException(
          '${response.statusCode}', Uri.parse(request.url));
    }
  }

  RequestTemplate _pre(String method, String url, Map<String, dynamic>? data) {
    _logger.i('$method $url $data');

    RequestTemplate request = RequestTemplate(url, method: method, body: data);
    for (var i = 0; i < interceptors.length; i++) {
      interceptors[i].onRequest(request);
    }
    return request;
  }

  ResponseTemplate _post(RequestTemplate request, http.Response response) {
    ResponseTemplate resp = ResponseTemplate(
        request: request, body: response.body, statusCode: response.statusCode);
    for (var i = 0; i < interceptors.length; i++) {
      interceptors[i].onResponse(resp);
    }
    return resp;
  }
}
