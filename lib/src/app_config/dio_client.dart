import 'package:campus_connect/src/app_config/dio_interceptor.dart';
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    headers: <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    receiveDataWhenStatusError: true,
  ),
)..interceptors.add(DioInterceptor());
