import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/controller/auth_controller.dart';
import 'package:campus_connect/src/controller/profile_controller.dart';
import 'package:campus_connect/src/view/auth/update_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController profileController = Get.find<ProfileController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Load profile when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.getProfile();
    });
  }

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
        child: Obx(() {
          if (profileController.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final profile = profileController.profile.value;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Picture and Basic Info
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.sp),
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60.r,
                            backgroundImage: profile?.image != null 
                                ? NetworkImage(profile!.image!) as ImageProvider
                                : AssetImage('assets/profile.png'),
                          ),
                          Container(
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: Color(0xff193670),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Get.to(() => UpdateProfilePicturePage());
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              padding: EdgeInsets.all(0.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        profile != null 
                            ? '${profile.firstName} ${profile.lastName}'
                            : 'User name',
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        read("isAdmin") == "true"  ? 'Admin' : 'Student',
                        style: TextStyle(
                            color: Color(0xff8E8E93),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Details Container
                Container(
                  padding: EdgeInsets.all(20.sp),
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Column(
                    children: [
                      _buildProfileItem(Icons.school, 'Semester', '${profile?.semester ?? 'N/A'}${_getOrdinal(profile?.semester)} Semester'),
                      _buildDivider(),
                      _buildProfileItem(Icons.numbers_outlined, 'Roll Number', profile?.rollNo ?? 'N/A'),
                      _buildDivider(),
                      _buildProfileItem(Icons.calendar_today, 'Date of Birth', profile?.dob ?? 'N/A'),
                      _buildDivider(),
                      _buildProfileItem(Icons.email, 'Email', profile?.email ?? 'N/A'),
                      _buildDivider(),
                      _buildProfileItem(Icons.book, 'Program', 'BIT'),
                      _buildDivider(),
                      _buildProfileItem(Icons.schedule, 'Shift', '${profile?.shift ?? 'N/A'} Shift'),
                      _buildDivider(),
                      _buildProfileItem(Icons.location_on, 'Address', profile?.address ?? 'N/A'),
                      _buildDivider(),
                      _buildProfileItem(Icons.phone, 'Contact Number', profile?.contact ?? 'N/A'),
                    ],
                  ),
                ),

                SizedBox(height: 20.h)
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Color(0xffFFFFFF),
            size: 22.sp,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Color(0xff8E8E93),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.withValues(alpha:0.3),
      height: 1.h,
    );
  }

  String _getOrdinal(int? semester) {
    if (semester == null) return '';
    switch (semester) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
}