import 'dart:developer';

import 'package:campus_connect/src/app_config/api_repo.dart';
import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/services/notification_services.dart';
import 'package:campus_connect/src/view/bottom_nav.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isLoginLoading = false.obs;

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
}
