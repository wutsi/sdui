import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

import 'analytics.dart';
import 'logger.dart';

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
    request.headers['Content-Type'] = 'application/json; charset=utf-8';
    request.headers['Accept'] = 'application/json; charset=utf-8';

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
    dynamic trace = sduiAnalytics.startTrace(url);

    RequestTemplate request = _pre('POST', url, data, []);
    http.Response? response;
    Exception? ex;
    try {
      response = await http.post(Uri.parse(request.url),
          body: request.body, headers: request.headers);
      _post(request, response, []);
      if (response.statusCode / 100 == 2) {
        return response.body;
      } else {
        ex = http.ClientException(
            response.statusCode.toString(), Uri.parse(request.url));
        throw ex;
      }
    } finally {
      sduiAnalytics.endTrace(trace);

      // Request headers
      String line = 'POST $url status=${response?.statusCode}';
      request.headers.forEach((key, value) {
        if (key == 'Authorization') {
          line += ' request_header_Authorization=***';
        } else {
          line += ' request_header_$key=$value';
        }
      });

      // Response
      if (response != null) {
        response.headers.forEach((key, value) {
          line += ' response_header_$key=$value';
        });
      }

      // Payload
      if (data != null) {
        line += ' request_payload=$data';
      }

      // Log
      if (ex != null) {
        _logger.e(line, ex);
      } else if (response == null || response.statusCode / 100 > 2) {
        _logger.e(line);
      } else {
        _logger.i(line);
      }
    }
  }

  Future<void> upload(String url, String name, XFile file) async {
    return uploadStream(url, name, file.path, file.readAsBytes().asStream(),
        file.mimeType, await file.length());
  }

  Future<void> uploadStream(String url, String name, path,
      Stream<Uint8List> stream, String? contentType, int contentLength) async {
    dynamic trace = sduiAnalytics.startTrace(url);

    RequestTemplate request = _pre('POST', url, {}, [HttpJsonInterceptor]);
    http.StreamedResponse? response;
    Exception? ex;
    try {
      String filename = path.split('/').last;

      var req = http.MultipartRequest('POST', Uri.parse(url));
      req.headers.addAll(request.headers);
      req.files.add(http.MultipartFile(name, stream, contentLength,
          filename: filename,
          contentType:
              contentType != null ? MediaType.parse(contentType) : null));

      response = await req.send();
    } finally {
      sduiAnalytics.endTrace(trace);

      // Request headers
      String line = 'POST $url status=${response?.statusCode}';
      request.headers.forEach((key, value) {
        if (key == 'Authorization') {
          line += ' request_header_Authorization=***';
        } else {
          line += ' request_header_$key=$value';
        }
      });

      // Log
      if (ex != null) {
        _logger.e(line, ex);
      } else {
        _logger.i(line);
      }
    }
  }

  RequestTemplate _pre(String method, String url, Map<String, dynamic>? data,
      List<Type> ignoreInterceptors) {
    RequestTemplate request = RequestTemplate(url, method: method, body: data);
    for (var i = 0; i < interceptors.length; i++) {
      var interceptor = interceptors[i];
      if (ignoreInterceptors.contains(interceptor.runtimeType)) continue;

      interceptor.onRequest(request);
    }
    return request;
  }

  ResponseTemplate _post(RequestTemplate request, http.Response response,
      List<Type> ignoreInterceptors) {
    ResponseTemplate resp = ResponseTemplate(
        request: request,
        body: response.body,
        statusCode: response.statusCode,
        headers: response.headers);
    for (var i = 0; i < interceptors.length; i++) {
      var interceptor = interceptors[i];
      if (ignoreInterceptors.contains(interceptor.runtimeType)) continue;

      interceptor.onResponse(resp);
    }
    return resp;
  }
}
