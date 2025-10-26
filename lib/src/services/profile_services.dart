import 'package:dio/dio.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  Future<Response> getProfile() async {
    return await _dio.get('auth/profile/');
  }

  Future<Response> updateProfile(FormData formData) async {
    return await _dio.patch(
      'auth/profile/',
      data: formData,
    );
  }
}