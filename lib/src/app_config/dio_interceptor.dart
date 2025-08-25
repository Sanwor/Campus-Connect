import 'dart:developer';
import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var token = read("token");

    // Bearer
    options.headers['Authorization'] = "Bearer $token";

    // Basic Auth
    // String username = "Admin";
    // String password = "admin123";

    // String basicAuth =
    //     'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    // options.headers['Authorization'] = basicAuth;
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(response, ResponseInterceptorHandler handler) async {
    String apiPath = response.requestOptions.path;
    String successLog =
        'SUCCESS PATH => [${response.requestOptions.method}] $apiPath';
    log('\x1B[32m$successLog\x1B[0m');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errormsg =
        'ERROR PATH => [${err.response!.requestOptions.method}] ${err.response!.requestOptions.path}';
    log('\x1B[31m$errormsg\x1B[0m');
    return super.onError(err, handler);
  }
}
