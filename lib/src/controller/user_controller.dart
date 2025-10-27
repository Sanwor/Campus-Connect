import 'dart:developer';
import 'package:campus_connect/src/model/user_model.dart';
import 'package:campus_connect/src/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService _userService = Get.find();
  RxBool isUserLoading = false.obs;
  RxList userList = [].obs;
  dynamic userDetails;

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  getUsers() async {
    isUserLoading.value = true;
    try {
      log('**Starting to fetch users...');
      final response = await _userService.getUsers();
      
      log('**API Response Status: ${response.statusCode}');
      log('**Response Data Type: ${response.data.runtimeType}');
      log('**Response Data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle different response structures
        if (response.data is List) {
          log('📋 Response is a List with ${response.data.length} items');
          var listOfData = [];
          for (var data in response.data) {
            log('👤 User Data: $data');
            listOfData.add(UserModel.fromJson(data));
          }
          userList.value = listOfData;
          log('✅ Successfully loaded ${userList.length} users');
        } 
        else if (response.data is Map) {
          log('🗺️ Response is a Map, keys: ${response.data.keys}');
          
          // Check common API response structures
          if (response.data.containsKey('results')) {
            log('📊 Found "results" key in response');
            var results = response.data['results'];
            if (results is List) {
              var listOfData = [];
              for (var data in results) {
                listOfData.add(UserModel.fromJson(data));
              }
              userList.value = listOfData;
            }
          } 
          else if (response.data.containsKey('data')) {
            log('📊 Found "data" key in response');
            var data = response.data['data'];
            if (data is List) {
              var listOfData = [];
              for (var item in data) {
                listOfData.add(UserModel.fromJson(item));
              }
              userList.value = listOfData;
            }
          }
          else if (response.data.containsKey('users')) {
            log('📊 Found "users" key in response');
            var users = response.data['users'];
            if (users is List) {
              var listOfData = [];
              for (var user in users) {
                listOfData.add(UserModel.fromJson(user));
              }
              userList.value = listOfData;
            }
          }
          else {
            log('⚠️ Unexpected Map structure: ${response.data}');
          }
        }
        else {
          log('❓ Unexpected response type: ${response.data.runtimeType}');
        }
      } else {
        log('❌ API returned status: ${response.statusCode}');
      }
    } catch (e) {
      log('💥 Error fetching users: $e');
      if (e is DioException) {
        log('🌐 Dio Error Details:');
        log('   Message: ${e.message}');
        log('   URL: ${e.requestOptions.uri}');
        log('   Headers: ${e.requestOptions.headers}');
        if (e.response != null) {
          log('   Response Status: ${e.response!.statusCode}');
          log('   Response Data: ${e.response!.data}');
        }
      }
    } finally {
      isUserLoading.value = false;
      log('🏁 Finished loading users. Total users: ${userList.length}');
    }
  }

  refreshUsers() async {
    log('🔄 Manual refresh triggered');
    await getUsers();
  }
}