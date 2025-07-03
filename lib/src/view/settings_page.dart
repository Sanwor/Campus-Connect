import 'package:campus_connect/src/view/login_page.dart';
import 'package:campus_connect/src/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF)),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100.sp),
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
            //profile and name
            Padding(
              padding: EdgeInsets.only(left: 40.sp),
              child: SizedBox(
                height: 100.h,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40.sp,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    SizedBox(width: 20.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'User name',
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'role',
                          style: TextStyle(
                              color: Color(0xff8E8E93),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            Divider(
              color: Color(0xff8E8E93),
              thickness: .5.sp,
            ),

            //settings components
            Padding(
              padding: EdgeInsets.only(left: 30.sp, top: 40.sp),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    //account
                    GestureDetector(
                      onTap: () => Get.to(() => ProfilePage()),
                      child: SizedBox(
                        width: 300.w,
                        height: 50.w,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/account.svg',
                            ),
                            SizedBox(width: 20.w),
                            Text(
                              'Account',
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    //notification
                    GestureDetector(
                      onTap: () => Get.to(() => ProfilePage()),
                      child: SizedBox(
                        width: 300.w,
                        height: 50.w,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/notification.svg',
                            ),
                            SizedBox(width: 20.w),
                            Text(
                              'Notification',
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    //settings
                    GestureDetector(
                      onTap: () => Get.to(() => ProfilePage()),
                      child: SizedBox(
                        width: 300.w,
                        height: 50.w,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/settings.svg',
                            ),
                            SizedBox(width: 20.w),
                            Text(
                              'Settings',
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    //logout
                    GestureDetector(
                      onTap: () {
                        Get.off(() => LoginPage());
                      },
                      child: SizedBox(
                        width: 300.w,
                        height: 50.w,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/logout.svg',
                            ),
                            SizedBox(width: 20.w),
                            Text(
                              'Logout',
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
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
