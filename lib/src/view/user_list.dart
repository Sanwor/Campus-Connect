import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

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
          'Users',
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
            Text(
              'Users List',
              style: TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual user count
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white.withOpacity(0.1),
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/profile.png'),
                      ),
                      title: Text(
                        'User ${index + 1}',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'user${index + 1}@example.com',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onTap: () {
                        // Navigate to user details or edit user
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}