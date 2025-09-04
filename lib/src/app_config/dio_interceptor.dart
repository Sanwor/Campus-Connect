import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 🔹 Using Basic Auth (username + password)
    const String username = "Admin";
    const String password = "admin123";

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    options.headers['Authorization'] = basicAuth;

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    String apiPath = response.requestOptions.path;
    String successLog =
        'SUCCESS PATH => [${response.requestOptions.method}] $apiPath';
    log('\x1B[32m$successLog\x1B[0m');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMsg =
        'ERROR PATH => [${err.requestOptions.method}] ${err.requestOptions.path}';
    log('\x1B[31m$errorMsg\x1B[0m');
    return super.onError(err, handler);
  }
}
