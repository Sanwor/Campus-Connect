import 'dart:convert';
import 'dart:developer';
import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Apply auth to ALL requests regardless of data type
    _applyAuthentication(options);

    log('REQUEST => [${options.method}] ${options.path} | Auth: ${options.headers['Authorization']?.substring(0, 15)}...');
    
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    String apiPath = response.requestOptions.path;
    String successLog =
        'SUCCESS PATH => [${response.requestOptions.method}] $apiPath - Status: ${response.statusCode}';
    log('\x1B[32m$successLog\x1B[0m');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMsg =
        'ERROR PATH => [${err.requestOptions.method}] ${err.requestOptions.path} - Status: ${err.response?.statusCode}';
    log('\x1B[31m$errorMsg\x1B[0m');
    log('ERROR RESPONSE: ${err.response?.data}');
    log('REQUEST HEADERS: ${err.requestOptions.headers}');
    
    return super.onError(err, handler);
  }

  // Main method to apply authentication
  void _applyAuthentication(RequestOptions options) {
    if (_requiresBasicAuth(options.path)) {
      _applyBasicAuth(options);
    } else {
      _applyBearerToken(options);
    }
  }

  // Helper method to apply Basic Auth
  void _applyBasicAuth(RequestOptions options) {
  const String username = "Admin";
  const String password = "admin123";
  
  // Try different encoding approaches
  String credentials = '$username:$password';
  String basicAuth = 'Basic ${base64Encode(utf8.encode(credentials))}';
  
  options.headers['Authorization'] = basicAuth;
  
  // Also try setting other headers that might be required
  options.headers['Content-Type'] = 'application/json';
  options.headers['Accept'] = 'application/json';
  
  log('APPLIED BASIC AUTH with: $username:$password');
  log('FULL AUTH HEADER: $basicAuth');
}

  // Helper method to apply Bearer Token
  void _applyBearerToken(RequestOptions options) {
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
    // List of specific endpoints that require Basic Auth (Notice APIs)
    final basicAuthEndpoints = [
      'notice/',
      'notices/',
    ];

    // List of endpoints that should use Bearer Token (Auth endpoints)
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
      return false; // Use Bearer Token instead of Basic Auth
    } else {
      log('-> USING BASIC AUTH (No user token)');
      return true; // Use Basic Auth as fallback
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