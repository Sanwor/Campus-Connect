import 'dart:developer';

import 'package:campus_connect/src/app_config/api_repo.dart';
import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/services/notification_services.dart';
import 'package:campus_connect/src/view/bottom_nav.dart';
import 'package:campus_connect/src/view/login_page.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class AuthController extends GetxController {
  RxBool isLoginLoading = false.obs;
  RxBool isRegisterLoading = false.obs;


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
  login({required String email, required String password}) async {
    isLoginLoading.value = true;

    var data = {
      "email": email,
      "password": password,
      // "fcm_token" : await NotificationService.getFcmToken()
    };

    try {
      var response = await ApiRepo.apiPost("auth/login/", data);
      
      if (response != null) {
        // Store tokens
        write("access_token", response["access"] ?? "");
        write("refresh_token", response["refresh"] ?? "");
        
        // Extract username from message
        String message = response["message"] ?? "";
        String? username;
        if (message.contains("Welcome back,")) {
          username = message.split("Welcome back,")[1].replaceFirst(".", "").trim();
          write("userName", username);
        }
        
        showToast("Login successful!");
        Get.offAll(() => BottomNavPage(initialIndex: 0));
      } else {
        // Handle error response
        String errorMessage = response["message"] ?? "Login failed";
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
  register({
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
    

    var data = FormData.fromMap({
      "email": email,
      "password": password,
      "password2": password2,
      "first_name": firstName,
      "last_name": lastName,
      "roll_no": rollNo,
      "semester": semester,
      "dob": dob, // BS format: YYYY-MM-DD
      "address": address,
      "shift": shift.toLowerCase(), // Convert to lowercase
      "image" :  await MultipartFile.fromFile(imagePath!)
    });

    try {
      var response = await ApiRepo.apiPost("auth/register/", data);
      
      if (response != null && (response.statusCode == 201 || response.statusCode == 200)) {
        // Registration successful
        showToast("Registration successful!");
        
        Get.offAll(() => LoginPage());
        // Optionally auto-login after registration
        // Get.offAll(() => BottomNavBar(initialIndex: 0));
        
      } else if (response != null && response.statusCode == 400) {
        // Handle validation errors
        String errorMessage = "Registration failed";
        if (response["detail"] != null) {
          errorMessage = response["detail"];
        } else if (response["email"] != null) {
          errorMessage = "Email: ${response["email"][0]}";
        } else if (response["password"] != null) {
          errorMessage = "Password: ${response["password"][0]}";
        } else if (response["profile"] != null) {
          errorMessage = "Profile: ${response["profile"][0]}";
        }
        showErrorToast(errorMessage);
      } else {
        showErrorToast("Registration failed. Please try again.");
      }
    } catch (e) {
      log(e.toString());
      showErrorToast("An error occurred during registration");
    } finally {
      isRegisterLoading.value = false;
    }
}
}
