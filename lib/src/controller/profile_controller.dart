import 'dart:developer';
import 'dart:io';
import 'package:campus_connect/src/services/profile_services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = Get.find();
  
  var isLoading = false.obs;
  var profile = Rx<ProfileModel?>(null);
  var errorMessage = ''.obs;

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _profileService.getProfile();
      
      if (response.statusCode == 200) {
        profile.value = ProfileModel.fromJson(response.data);
        log('✅ Profile loaded successfully');
      } else {
        errorMessage.value = 'Failed to load profile';
        log('❌ Profile load failed: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Error loading profile: $e';
      log('❌ Profile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? rollNo,
    int? semester,
    String? dob,
    String? address,
    String? shift,
    String? imagePath,
  }) async {
    try {
      isLoading.value = true;
      
      var formData = FormData.fromMap({
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (rollNo != null) 'roll_no': rollNo,
        if (semester != null) 'semester': semester,
        if (dob != null) 'dob': dob,
        if (address != null) 'address': address,
        if (shift != null) 'shift': shift,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _profileService.updateProfile(formData);
      
      if (response.statusCode == 200) {
        // Refresh profile data
        await getProfile();
        Get.snackbar('Success', 'Profile updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
  try {
    isLoading.value = true;
    
    var formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile.path),
    });

    final response = await _profileService.updateProfile(formData);
    
    if (response.statusCode == 200) {
      // Refresh profile data to get updated image
      await getProfile();
    } else {
      throw Exception('Failed to update profile picture');
    }
  } catch (e) {
    rethrow;
  } finally {
    isLoading.value = false;
  }
}
}