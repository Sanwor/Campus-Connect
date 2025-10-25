import 'dart:developer';

import 'package:dio/dio.dart';

class NoticeService {
  final Dio _dio;

  NoticeService(this._dio);

  // Get all notices
  Future<Response> getNotices() async {
    return await _dio.get('notices/');
  }

  // Get single notice detail
  Future<Response> getNoticeDetail(int id) async {
    return await _dio.get('notices/$id/');
  }

  // Create notice with FormData
  Future<Response> createNotice(FormData formData) async {
    return await _dio.post(
      'notices/',
      data: formData,
      // Remove the Options header override as it might be removing the Authorization header
    );
  }

  // Update notice with FormData
  // Future<Response> updateNotice(int id, FormData formData) async {
  //   return await _dio.patch(
  //     'notices/$id/',
  //     data: formData,
  //     // Remove the Options header override as it might be removing the Authorization header
  //   );
  // }
  // Update your NoticeService updateNotice method
Future<Response> updateNotice(int id, FormData formData) async {
  // Convert FormData to regular JSON to test if FormData is the issue
  Map<String, dynamic> jsonData = {};
  
  // Extract data from FormData for testing
  formData.fields.forEach((field) {
    jsonData[field.key] = field.value;
  });
  
  // Try with JSON first
  try {
    log('Trying JSON update...');
    return await _dio.patch(
      'notices/$id/',
      data: jsonData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  } catch (e) {
    log('JSON update failed, trying FormData...');
    // Fall back to FormData
    return await _dio.patch(
      'notices/$id/',
      data: formData,
    );
  }
}

  // Delete notice
  Future<Response> deleteNotice(int id) async {
    return await _dio.delete('notices/$id/');
  }
}