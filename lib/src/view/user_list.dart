import 'package:campus_connect/src/controller/user_controller.dart';
import 'package:campus_connect/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: const Color(0xffFFFFFF),
        ),
        centerTitle: true,
        title: Text(
          'Users',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xffFFFFFF),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xffFFFFFF)),
            onPressed: userController.refreshUsers,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 120.sp),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff020826),
              Color(0xff204486),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Users List',
              style: TextStyle(
                color: const Color(0xffFFFFFF),
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            Expanded(
              child: Obx(() {
                if (userController.isUserLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                
                if (userController.userList.isEmpty) {
                  return Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: userController.userList.length,
                  itemBuilder: (context, index) {
                    final user = userController.userList[index];
                    return _buildUserCard(user);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      color: Colors.white.withValues(alpha: 0.2),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
              ? NetworkImage(user.profileImage!)
              : const AssetImage('assets/profile.png') as ImageProvider,
          radius: 20.r,
        ),
        title: Text(
          user.fullName,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        subtitle: Text(
          user.email,
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.sp),
        onTap: () => _showUserDetails(user),
      ),
    );
  }

  void _showUserDetails(UserModel user) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff204486),
        title: Text(
          'User Details',
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', user.id.toString()),
              _buildDetailRow('Username', user.username),
              _buildDetailRow('Email', user.email),
              _buildDetailRow('First Name', user.firstName),
              _buildDetailRow('Last Name', user.lastName),
              _buildDetailRow('Staff', user.isStaff.toString()),
              _buildDetailRow('Roll No', user.rollNo),
              _buildDetailRow('Date of Birth', user.dateOfBirth),
              _buildDetailRow('Address', user.address),
              _buildDetailRow('Shift', user.shift),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close', 
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  
}