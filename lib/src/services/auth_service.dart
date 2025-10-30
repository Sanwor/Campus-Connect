import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<Response> login(String email, String password, String? fcmToken) async {
    var data = {
      "email": email,
      "password": password,
    };
    
    // Add FCM token only if it's not null and not empty
    if (fcmToken != null && fcmToken.isNotEmpty) {
      data["fcm_token"] = fcmToken;
    }

    return await _dio.post(
      'auth/login/',
      data: data,
    );
  }

  //register user
  Future<Response> register(FormData formData) async {
    return await _dio.post(
      'admission-records/', 
      data: formData,
    );
  }

  //change password
  Future<Response> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    return await _dio.post(
      'auth/change-password/',
      data: {
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_new_password": confirmNewPassword,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  //refresh token
  Future<Response> refreshToken(String refreshToken) async {
    return await _dio.post('auth/refresh/', data: {
      'refresh': refreshToken,
    });
  }

  //get user profile
  Future<Response> getUserProfile() async {
    return await _dio.get('user/profile/');
  }
}