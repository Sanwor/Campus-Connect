import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Color(0xffFFFFFF),
        ),
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF)),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 120.sp),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff020826),
                Color(0xff204486),
              ]),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60.sp,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            SizedBox(height: 20.h),
            Text(
              'User name',
              style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              'student',
              style: TextStyle(
                  color: Color(0xff8E8E93),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400),
            ),

            //details container
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 30.sp, top: 50.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Roll No.:',
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Programme:',
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Year/shift:',
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Address:',
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Contact No.:',
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'DOB:',
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
