import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<Response> login(String email, String password) async {
    return await _dio.post('auth/login/', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register(FormData formData) async {
    return await _dio.post(
      'auth/register/', 
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> refreshToken(String refreshToken) async {
    return await _dio.post('auth/refresh/', data: {
      'refresh_token': refreshToken,
    });
  }

  Future<Response> getUserProfile() async {
    return await _dio.get('user/profile/');
  }
}