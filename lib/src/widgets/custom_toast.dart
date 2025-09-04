import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

showToast(message) {
  return Get.snackbar(
    "",
    "",
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    messageText: const SizedBox.shrink(),
    titleText: Row(
      children: [
        Expanded(
          child: Text(
            message.toString(),
          ),
        ),
      ],
    ),
  );
}

showErrorToast(message) {
  return Get.snackbar(
    "",
    "",
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    messageText: const SizedBox.shrink(),
    titleText: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Icon(
          Icons.info,
          color: Colors.red,
        )),
        SizedBox(
          width: 6.w,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              message.toString(),
            ),
          ),
        ),
      ],
    ),
  );
}
