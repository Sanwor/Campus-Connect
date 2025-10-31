import 'dart:developer';

import 'package:dio/dio.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  Future<Response> getProfile() async {
    try {
      final response = await _dio.get('auth/profile/');
      log(' Profile API Response Status: ${response.statusCode}');
      log(' Profile API Response Data: ${response.data}');
      return response;
    } catch (e) {
      log('** Profile API Error: $e');
      rethrow;
    }
  }

  Future<Response> updateProfile(FormData formData) async {
    return await _dio.patch(
      'auth/profile/',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }
}