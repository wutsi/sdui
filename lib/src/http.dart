import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sdui/src/logger.dart';

class RequestTemplate {
  Map<String, String> headers = {};
  String method;
  String url = '';
  Object? body;
  Encoding? encoding;

  RequestTemplate(this.url, {this.method = '', this.body, this.encoding});
}

class ResponseTemplate {
  RequestTemplate request;
  Map<String, String> headers;
  String body;
  int statusCode = 200;

  ResponseTemplate({
    required this.request,
    required this.headers,
    this.body = '',
    this.statusCode = 200,
  });
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
  final Logger _logger = LoggerFactory.create('Http');

  Http._internal();

  factory Http() {
    return _singleton;
  }

  static Http getInstance() => _singleton;

  Future<String> post(String url, Map<String, dynamic>? data) async {
    RequestTemplate request = _pre('POST', url, data);
    http.Response? response;
    Exception? ex;
    try {
      response = await http.post(Uri.parse(request.url),
          body: request.body, headers: request.headers);
      _post(request, response);
      if (response.statusCode / 100 == 2) {
        return response.body;
      } else {
        ex = http.ClientException(
            '${response.statusCode}', Uri.parse(request.url));
        throw ex;
      }
    } finally {
      String line = 'POST $url';
      line += ' request_headers=${request.headers}';
      if (data != null) {
        line += ' request_payload=$data';
      }
      if (response != null) {
        line +=
            ' response_status=${response.statusCode} response_headers=${response.headers}';
      }
      _logger.i(line);
    }
  }

  RequestTemplate _pre(String method, String url, Map<String, dynamic>? data) {
    RequestTemplate request = RequestTemplate(url, method: method, body: data);
    for (var i = 0; i < interceptors.length; i++) {
      interceptors[i].onRequest(request);
    }
    return request;
  }

  ResponseTemplate _post(RequestTemplate request, http.Response response) {
    ResponseTemplate resp = ResponseTemplate(
        request: request,
        body: response.body,
        statusCode: response.statusCode,
        headers: response.headers);
    for (var i = 0; i < interceptors.length; i++) {
      interceptors[i].onResponse(resp);
    }
    return resp;
  }
}
