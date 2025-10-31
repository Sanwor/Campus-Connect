import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/controller/profile_controller.dart';
import 'package:campus_connect/src/view/auth/change_password.dart';
import 'package:campus_connect/src/view/auth/login_page.dart';
import 'package:campus_connect/src/view/event_list.dart';
import 'package:campus_connect/src/view/notification_page.dart';
import 'package:campus_connect/src/view/profile_page.dart';
import 'package:campus_connect/src/view/user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MenuPage extends StatefulWidget {
  final ProfileController profController = Get.find<ProfileController>();
  MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    initialise();
  }

  initialise() {
    widget.profController.getProfile();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Menu',
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
            Obx(
              (){
                final profile = widget.profController.profile.value;
                final fullName = "${profile?.firstName ?? ''} ${profile?.lastName ?? ''}".trim();
                return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.h),
                child: Container(
                  height: 100.h,
                        padding: EdgeInsets.all(20.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r)
                        ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40.sp,
                        backgroundImage: read("isAdmin") == "true" ? AssetImage('assets/profile.png')
                        :profile?.image != null 
                            ? NetworkImage(profile!.image!) as ImageProvider
                            : AssetImage('assets/profile.png'),
                      ),
                      SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            read("isAdmin") != "true" ? fullName : "Admin",
                            style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            read("isAdmin") != "true" ? "Student" : "Admin",
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
              );
              }
            ),

            Divider(
              color: Color(0xff8E8E93),
              thickness: 0.5.sp,
            ),

            //settings components
            Padding(
              padding: EdgeInsets.only(top: 40.h, left: 30.w, right: 30.w),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    //account
                    InkWell(
                      onTap: () {
                        if (read("isAdmin") == "true" ) {
                          Get.to(() => UsersPage()); // Navigate to Users list for admin
                        } else {
                          Get.to(() => ProfilePage()); // Navigate to Profile for students
                        }
                      },
                      child: Container(
                        height: 60.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10.r)
                        ),
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
                    InkWell(
                      onTap: () => Get.to(() => NotificationPage()),
                      child: Container(
                        height: 60.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10.r)
                        ),
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

                    //events
                    InkWell(
                      onTap: () => Get.to(() => EventsPage()),
                      child: Container(
                        height: 60.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month_outlined,color: Colors.white,),
                            SizedBox(width: 20.w),
                            Text(
                              'Events',
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

                    //change password
                    InkWell(
                      onTap: () => Get.to(() => ChangePasswordPage()),
                      child: Container(
                        height: 60.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lock_reset, color: Colors.white,),
                            SizedBox(width: 20.w),
                            Text(
                              'Change Password',
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    //logout
                    InkWell(
                      onTap: () {
                        remove('isLoggedIn');
                        Get.off(() => LoginPage());
                        clearAllData();
                      },
                      child: Container(
                        height: 60.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/logout.svg',
                                colorFilter: ColorFilter.mode(
                                    Color(0xffD73800), BlendMode.srcIn)),
                            SizedBox(width: 20.w),
                            Text(
                              'Logout',
                              style: TextStyle(
                                  color: Color(0xffD73800),
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
