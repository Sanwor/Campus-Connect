import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/view/bottom_nav/bottom_nav.dart';
import 'package:campus_connect/src/view/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1500), () {
      // ignore: use_build_context_synchronously
      if (read("access_token") != "") {
        Get.offAll(() => BottomNavPage(
              initialIndex: 0,
            ));
      } else {
        Get.off(() => LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xff020826),
              Color(0xff204486),
            ])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/mainlogo.png',
                height: 100.h,
                width: 280.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
