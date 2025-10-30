import 'package:flutter/material.dart';
import 'package:get/get.dart';

showToast(message) {
  return Get.snackbar(
    "Success",
    message,
    backgroundColor: Colors.green.shade700,
    colorText: Colors.white,
    icon: Icon(Icons.check_circle, color: Colors.white),
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(10),
    borderRadius: 8,
  );
}

showErrorToast(String message) {
  return Get.snackbar(
    "Error",
    message,
    backgroundColor: Colors.red.shade700,
    colorText: Colors.white,
    icon: Icon(Icons.error_outline, color: Colors.white),
    shouldIconPulse: true,
    duration: Duration(seconds: 3),
    snackPosition: SnackPosition.TOP,
    margin: EdgeInsets.all(10),
    borderRadius: 8,
  );
}
