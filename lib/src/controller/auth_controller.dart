import 'dart:developer';

import 'package:campus_connect/src/app_config/api_repo.dart';
import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/controller/profile_controller.dart';
import 'package:campus_connect/src/services/auth_service.dart';
import 'package:campus_connect/src/services/notification_services.dart';
import 'package:campus_connect/src/view/bottom_nav.dart';
import 'package:campus_connect/src/view/login_page.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class AuthController extends GetxController {
  final AuthService _authService = Get.find();
  RxBool isLoginLoading = false.obs;
  RxBool isRegisterLoading = false.obs;
  var username = ''.obs;
  RxBool isAdmin = false.obs; 


  // Future<void> login(String email, String password) async {
  //   try {
  //     isLoginLoading.value = true;

  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //   } catch (e) {
  //     Get.snackbar("Login Failed", e.toString());
  //   } finally {
  //     isLoginLoading.value = false;
  //   }
  // }

  // Login
  Future<void> login({required String email, required String password}) async {
    isLoginLoading.value = true;

    ///old function for auth
    // var data = {
    //   "email": email,
    //   "password": password,
    //   // "fcm_token" : await NotificationService.getFcmToken()
    // };

    try {
      // var response = await ApiRepo.apiPost("auth/login/", data);
      final response = await _authService.login(email, password);
      
      if (response.statusCode == 200 || response.statusCode == 201 ) {
        // Store tokens
        write("access_token", response.data["access"] ?? "");
        write("refresh_token", response.data["refresh"] ?? "");

        // DEBUG: Print the entire response to see available fields
        log('🔍 LOGIN RESPONSE DATA: ${response.data}');
        log('🔍 LOGIN RESPONSE KEYS: ${response.data.keys}');
        
        // Extract username from message
        String message = response.data["message"] ?? "";
      if (message.contains("Welcome back,")) {
        String username = message.split("Welcome back,")[1].replaceFirst(".", "").trim();
        write("userName", username);
        this.username.value = username; // Also store in controller
      }

      /// Extract and save user role (admin or not)
      bool isAdminUser = _checkIfAdmin(response.data);
      log('🔍 IS ADMIN RESULT: $isAdminUser');
      write("isAdmin", isAdminUser.toString());
      isAdmin.value = isAdminUser;
        
        showToast("Login successful!");
        Get.offAll(() => BottomNavPage(initialIndex: 0));
      } else {
        // Handle error response
        String errorMessage = response.data["message"] ?? "Login failed";
        showErrorToast(errorMessage);
      }
    } catch (e) {
      log(e.toString());
      showToast(e.toString());
    } finally {
      isLoginLoading.value = false;
    }
  }

  // Register
  Future<void> register({
    required String email,
    required String password,
    required String password2,
    required String firstName,
    required String lastName,
    required String rollNo,
    required String semester,
    required String dob, // Format: YYYY-MM-DD (AD)
    required String address,
    required String shift, // 'morning' or 'day'
    String? imagePath,
  }) async {
    isRegisterLoading.value = true;

    try {
      var data = FormData.fromMap({
        "email": email,
        "password": password,
        "password2": password2,
        "first_name": firstName,
        "last_name": lastName,
        "roll_no": rollNo,
        "semester": semester,
        "dob": dob,
        "address": address,
        "shift": shift.toLowerCase(),
        "image": imagePath != null ? await MultipartFile.fromFile(imagePath) : null,
      });

      final response = await _authService.register(data);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Registration successful
        Get.snackbar('Success', 'Registration successful!');
        
        // Navigate to login page
        Get.offAll(() => LoginPage());
        
        // Optionally auto-login after registration
        // Get.offAllNamed('/home');
        
      } else if (response.statusCode == 400) {
        // Handle validation errors
        String errorMessage = "Registration failed";
        if (response.data["detail"] != null) {
          errorMessage = response.data["detail"];
        } else if (response.data["email"] != null) {
          errorMessage = "Email: ${response.data["email"][0]}";
        } else if (response.data["password"] != null) {
          errorMessage = "Password: ${response.data["password"][0]}";
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
      // Extract username from the welcome message
      String message = responseData["message"] ?? "";
      
      if (message.contains("Welcome back,")) {
        String username = message.split("Welcome back,")[1].replaceFirst(".", "").trim();
        
        // Simple check - if username is "Admin" (exactly as in your message)
        bool isAdminUser = username == "Admin";
        
        log('🔍 ADMIN CHECK - Username: "$username", Is Admin: $isAdminUser');
        return isAdminUser;
      }
      
      return false;
    }

    // Add logout method to clear admin status
  void logout() {
    write("access_token", "");
    write("refresh_token", "");
    write("userName", "");
    write("isAdmin", "false");
    username.value = '';
    isAdmin.value = false;

    // Clear profile data
    final ProfileController profileController = Get.find<ProfileController>();
    profileController.profile.value = null;
    
    Get.offAllNamed('login/');
  }
  }
