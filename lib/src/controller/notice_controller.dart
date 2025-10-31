import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:campus_connect/src/model/noticeDetail_model.dart';
import 'package:campus_connect/src/model/notice_model.dart';
import 'package:campus_connect/src/services/notice_service.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class NoticeController extends GetxController {
  final NoticeService _noticeService = Get.find();
  RxBool isNoticeLoading = false.obs;
  RxBool isNoticeDetailsLoading = false.obs;
  RxBool isNoticePostLoading = false.obs;
  RxBool isNoticeDeleting = false.obs;
  RxBool isNoticePatchLoading = false.obs;
  RxList noticeList = [].obs;
  dynamic noticeDetails;

  getNoticeList() async {
    isNoticeLoading.value = true;
    try {
      final response = await _noticeService.getNotices();
      if (response.statusCode == 200 || response.statusCode == 201) {
        var listOfData = [];
        for (var data in response.data) { // Access response.data
          listOfData.add(NoticeModel.fromJson(data));
        }
        noticeList.value = listOfData;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isNoticeLoading.value = false;
    }
  }

  getNoticeDetails(id) async {
    isNoticeDetailsLoading.value = true;
    try {
      // Using NoticeService for GET notice details
      final response = await _noticeService.getNoticeDetail(id);
      if (response.statusCode == 200) {
        var data = NoticeDetailsModel.fromJson(response.data);
        noticeDetails = data;
      }
    } catch (e) {
      log(e.toString());
      showErrorToast(e.toString());
    } finally {
      isNoticeDetailsLoading.value = false;
    }
  }

  postNotice({
    required String title,
    required String details,
    required File? noticeImage,
  }) async {
    isNoticePostLoading.value = true;
    try {
      Map<String, dynamic> formMap = {
        "title": title,
        "content": details,
      };

      if (noticeImage != null) {
        formMap["featured_image"] = await MultipartFile.fromFile(noticeImage.path);
      }

      FormData formData = FormData.fromMap(formMap);

      // Using NoticeService instead of ApiRepo
      final response = await _noticeService.createNotice(formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        showToast("Notice posted successfully!");
        await getNoticeList(); // refresh list
      }
    } catch (e, stack) {
      log("Error posting notice: $e");
      log(stack.toString());
      showErrorToast("Failed to post notice");
    } finally {
      isNoticePostLoading.value = false;
    }
  }

  patchNotice(id, {title, details, noticeImage}) async {
    isNoticePatchLoading.value = true;
    try {
      Map<String, dynamic> formMap = {
        "title": title,
        "content": details,
      };

      if (noticeImage != null) {
        formMap["featured_image"] = await MultipartFile.fromFile(
          noticeImage.path,
        );
      }

      FormData formData = FormData.fromMap(formMap);

      // Using NoticeService instead of ApiRepo
      final response = await _noticeService.updateNotice(id, formData);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        showToast('Notice updated successfully!');
        getNoticeList();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isNoticePatchLoading.value = false;
    }
  }

  deleteNotice(id) async {
    try {
      isNoticeDetailsLoading.value = true;

      // Using NoticeService instead of ApiRepo
      final response = await _noticeService.deleteNotice(id);

      if (response.statusCode == 200 || response.statusCode == 204) {
        showToast("Notice deleted successfully");
        log("Notice with id $id deleted successfully");

        // Refresh notice list
        await getNoticeList();
      }
    } catch (e) {
      log("Error deleting notice: ${e.toString()}");
    } finally {
      isNoticeDetailsLoading.value = false;
    }
  }

  // Add to your NoticeController
testCredentialsDirectly() async {
  try {
    final dio = Dio();
    
    const String username = "Admin";
    const String password = "admin123";
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    
    log('Testing credentials: $username:$password');
    log('Base64: ${base64Encode(utf8.encode('$username:$password'))}');
    
    // Test with a simple GET first
    final response = await dio.get(
      'http://192.168.1.4:8000/api/notices/',
      options: Options(headers: {
        'Authorization': basicAuth,
      }),
    );
    
    log('✅ GET TEST SUCCESS: ${response.statusCode}');
    log('Response data: ${response.data}');
    
    return true;
  } catch (e) {
    log('❌ GET TEST FAILED: $e');
    if (e is DioException) {
      log('Error response: ${e.response?.data}');
      log('Error status: ${e.response?.statusCode}');
    }
    return false;
  }
}


// Test both GET and PATCH with the same credentials
testBothMethods() async {
  try {
    final dio = Dio();
    
    const String username = "Admin";
    const String password = "admin123";
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    
    // Test GET
    log('Testing GET...');
    final getResponse = await dio.get(
      'http://192.168.1.4:8000/api/notices/',
      options: Options(headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      }),
    );
    log('✅ GET Success: ${getResponse.statusCode}');
    
    // Test PATCH with simple data
    log('Testing PATCH...');
    final patchResponse = await dio.patch(
      'http://192.168.1.4:8000/api/notices/2/',
      data: {
        "title": "Test Update",
        "content": "Test content"
      },
      options: Options(headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      }),
    );
    log('✅ PATCH Success: ${patchResponse.statusCode}');
    
  } catch (e) {
    log('❌ Test failed: $e');
    if (e is DioException) {
      log('Error details: ${e.response?.data}');
    }
  }
}
}