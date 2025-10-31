import 'dart:developer';
import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/controller/profile_controller.dart';
import 'package:campus_connect/src/services/auth_service.dart';
import 'package:campus_connect/src/services/fcm_services.dart';
import 'package:campus_connect/src/services/notification_services.dart';
import 'package:campus_connect/src/view/bottom_nav/bottom_nav.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;

class AuthController extends GetxController {
  final AuthService _authService = Get.find();
  RxBool isLoginLoading = false.obs;
  RxBool isRegisterLoading = false.obs;
  var username = ''.obs;

  // Add refresh token method
  Future<bool> refreshAuthToken() async {
    try {
      String? refreshToken = read("refresh_token");
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _authService.refreshToken(refreshToken);
      
      if (response.statusCode == 200) {
        write("access_token", response.data["access"] ?? "");
        // Update refresh token if a new one is provided
        if (response.data["refresh"] != null) {
          write("refresh_token", response.data["refresh"]);
        }
        log('Token refreshed successfully');
        return true;
      }
    } catch (e) {
      log('Token refresh failed: $e');
    }
    return false;
  }

  // Updated login method with FCM token
  Future<void> login({ 
    required String email, 
    required String password, 
  }) async {
    isLoginLoading.value = true;

    try {
      // Get FCM token first with error handling
      final FCMService fcmService = Get.find<FCMService>();
      String? fcmToken;
      try {
        // fcmToken = await NotificationService.getFcmToken();
        fcmToken = await fcmService.getFCMToken();
        log("FCM Token: $fcmToken");
      } catch (e) {
        log("**Could not get FCM token: $e");
        fcmToken = null;
      }

      final response = await _authService.login(email, password, fcmToken);

      if (response.statusCode == 200 || response.statusCode == 201) {
        write("access_token", response.data["access"] ?? "");
        write("refresh_token", response.data["refresh"] ?? "");

        log('LOGIN RESPONSE DATA: ${response.data}');
        log('LOGIN RESPONSE KEYS: ${response.data.keys}');

        String message = response.data["message"] ?? "";
        if (message.contains("Welcome back,")) {
          String username = message.split("Welcome back,")[1].replaceFirst(".", "").trim();
          write("userName", username);
          this.username.value = username;
        }

        bool isAdminUser = _checkIfAdmin(response.data);
        log('IS ADMIN RESULT: $isAdminUser');
        write("isAdmin", isAdminUser.toString());

        showToast("Login successful!");
        Get.offAll(() => BottomNavPage(initialIndex: 0));
      } else {
        String errorMessage = response.data["message"] ?? "Login failed";
        showErrorToast(errorMessage);
      }
    } catch (e) {
      log("**Login error: $e");
      if (e is DioException) {
        if (e.response != null) {
          log('Server response: ${e.response!.data}');
          log('Status code: ${e.response!.statusCode}');
          
          if (e.response!.statusCode == 500) {
            showErrorToast("Server error. Please try again.");
          } else if (e.response!.statusCode == 400) {
            String errorMsg = e.response!.data["message"] ?? "Invalid email or password";
            showErrorToast(errorMsg);
          } else {
            showErrorToast("Login failed. Please try again.");
          }
        } else {
          showErrorToast("Network error. Check your connection.");
        }
      } else {
        showErrorToast("An unexpected error occurred");
      }
    } finally {
      isLoginLoading.value = false;
    }
  }

  // Register method (keep existing)
  Future<void> register({
    required String email,
    required String firstName,
    required String lastName,
    required String rollNo,
    required String semester,
    required String dob,
    required String address,
    required String shift,
    required String prog,
    required String contact,
    String? imagePath,
  }) async {
    isRegisterLoading.value = true;

    try {
      var data = FormData.fromMap({
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "roll_no": rollNo,
        "semester": semester,
        "dob": dob,
        "address": address,
        "shift": shift.toLowerCase(),
        "programme": prog,
        "contact_no": contact,
        "image": imagePath != null ? await MultipartFile.fromFile(imagePath) : null,
      });

      final response = await _authService.register(data);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Registration successful!');
        
        // Add a small delay before navigation
        await Future.delayed(Duration(milliseconds: 500));
        Get.back();
        } else if (response.statusCode == 400) {
        String errorMessage = "Registration failed";
        if (response.data["detail"] != null) {
          errorMessage = response.data["detail"];
        } else if (response.data["email"] != null) {
          errorMessage = "Email: ${response.data["email"][0]}";
        } else if (response.data["profile"] != null) {
          errorMessage = "Profile: ${response.data["profile"][0]}";
        }
        Get.snackbar('Error', errorMessage);
      } else {
        Get.snackbar('Error', "Registration failed. Please try again.");
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', "An error occurred during registration");
    } finally {
      isRegisterLoading.value = false;
    }
  }

  // Method to determine if user is admin
  bool _checkIfAdmin(Map<String, dynamic> responseData) {
    String message = responseData["message"] ?? "";
    
    if (message.contains("Welcome back,")) {
      String username = message.split("Welcome back,")[1].replaceFirst(".", "").trim();
      bool isAdminUser = username == "Admin";
      log('🔍 ADMIN CHECK - Username: "$username", Is Admin: $isAdminUser');
      return isAdminUser;
    }
    
    return false;
  }

  // Logout method
  void logout() {
    username.value = '';
    clearAllData();
    final ProfileController profileController = Get.find<ProfileController>();
    profileController.profile.value = null;
    Get.offAllNamed('login/');
  }
}