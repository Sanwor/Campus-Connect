import 'package:dio/dio.dart';

class UserService {
  final Dio _dio;

  UserService(this._dio);

  // Get all users
  Future<Response> getUsers() async {
    return await _dio.get('users/');
  }
}