import 'dart:convert';
import 'dart:developer';
import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide Response;
import 'package:campus_connect/src/controller/auth_controller.dart';

class DioInterceptor extends dio.Interceptor {
  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    _applyAuthentication(options);
    log('REQUEST => [${options.method}] ${options.path} | Auth: ${options.headers['Authorization']?.substring(0, 15)}...');
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) async {
    String apiPath = response.requestOptions.path;
    String successLog =
        'SUCCESS PATH => [${response.requestOptions.method}] $apiPath - Status: ${response.statusCode}';
    log('\x1B[32m$successLog\x1B[0m');
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(dio.DioException err, dio.ErrorInterceptorHandler handler) async {
    String errorMsg =
        'ERROR PATH => [${err.requestOptions.method}] ${err.requestOptions.path} - Status: ${err.response?.statusCode}';
    log('\x1B[31m$errorMsg\x1B[0m');
    log('ERROR RESPONSE: ${err.response?.data}');
    log('REQUEST HEADERS: ${err.requestOptions.headers}');
    
    // Handle token expiration (401/403 errors)
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      final errorData = err.response?.data;
      if (errorData is Map && errorData['code'] == 'token_not_valid') {
        log('🔄 Token expired, attempting refresh...');
        
        try {
          final authController = Get.find<AuthController>();
          bool refreshed = await authController.refreshAuthToken();
          
          if (refreshed) {
            log('✅ Token refreshed successfully, retrying request...');
            
            // Get new token
            final newToken = read("access_token");
            
            if (newToken != null && newToken.isNotEmpty) {
              // Create new request with updated token
              final newOptions = dio.Options(
                method: err.requestOptions.method,
                headers: {
                  ...err.requestOptions.headers,
                  'Authorization': 'Bearer $newToken',
                },
              );
              
              // Retry the original request
              final dioInstance = dio.Dio();
              try {
                final response = await dioInstance.request(
                  err.requestOptions.uri.toString(),
                  data: err.requestOptions.data,
                  queryParameters: err.requestOptions.queryParameters,
                  options: newOptions,
                );
                log('🔄 Retry successful: ${response.statusCode}');
                return handler.resolve(response);
              } catch (retryError) {
                log('❌ Retry failed: $retryError');
                return handler.next(err);
              }
            }
          } else {
            log('❌ Token refresh failed, user needs to login again');
          }
        } catch (refreshError) {
          log('❌ Token refresh error: $refreshError');
        }
      }
    }
    
    return super.onError(err, handler);
  }

  // Main method to apply authentication
  void _applyAuthentication(dio.RequestOptions options) {
    if (_requiresBasicAuth(options.path)) {
      _applyBasicAuth(options);
    } else {
      _applyBearerToken(options);
    }
  }

  // Helper method to apply Basic Auth
  void _applyBasicAuth(dio.RequestOptions options) {
    const String username = "Admin";
    const String password = "admin123";
    
    String credentials = '$username:$password';
    String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials))}';
    
    options.headers['Authorization'] = basicAuth;
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    
    log('APPLIED BASIC AUTH with: $username:$password');
    log('FULL AUTH HEADER: $basicAuth');
  }

  // Helper method to apply Bearer Token
  void _applyBearerToken(dio.RequestOptions options) {
    String token = read("access_token") ?? "";
    if (token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
      log('APPLIED BEARER TOKEN for: ${options.path}');
    } else {
      log('NO AUTH for: ${options.path}');
    }
  }

  // Enhanced method to determine which endpoints require Basic Auth
  bool _requiresBasicAuth(String path) {
    final basicAuthEndpoints = [
      'notice/',
      'notices/',
    ];

    final bearerTokenEndpoints = [
      'auth/login/',
      'auth/register/',
      'auth/refresh/',
      'auth/logout/',
      'user/',
      'profile/',
    ];

    log('CHECKING AUTH FOR PATH: $path');

    // Check if it's a bearer token endpoint first
    if (bearerTokenEndpoints.any((endpoint) => path.contains(endpoint))) {
      log('-> USING BEARER TOKEN (Auth endpoint)');
      return false;
    }

    // For notice endpoints, use Bearer Token if user is logged in as admin
    if (basicAuthEndpoints.any((endpoint) => path.contains(endpoint))) {
      String token = read("access_token") ?? "";
      if (token.isNotEmpty) {
        log('-> USING BEARER TOKEN (User is logged in)');
        return false;
      } else {
        log('-> USING BASIC AUTH (No user token)');
        return true;
      }
    }

    // Check if it's a basic auth endpoint
    if (basicAuthEndpoints.any((endpoint) => path.contains(endpoint))) {
      log('-> USING BASIC AUTH (Notice endpoint)');
      return true;
    }

    // Default: For all other endpoints, use Bearer Token if available
    String token = read("access_token") ?? "";
    bool useBasicAuth = token.isEmpty;
    log('-> DEFAULT: ${useBasicAuth ? "BASIC AUTH (no token)" : "BEARER TOKEN"}');
    
    return useBasicAuth;
  }
}