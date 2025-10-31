import 'package:campus_connect/src/services/auth_service.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _isLoading = false.obs;
  final AuthService _authService = Get.find<AuthService>();

  bool _isOldPasswordObscure = true;
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;
      
      try {
        final response = await _authService.changePassword(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmNewPassword: _confirmPasswordController.text,
        );
        
        if (response.statusCode == 200) {
          Get.back();
          showToast('Password changed successfully',
          );
        } else {
          // Handle API error responses
          String errorMessage = 'Failed to change password';
          if (response.data['detail'] != null) {
            errorMessage = response.data['detail'];
          } else if (response.data['old_password'] != null) {
            errorMessage = "Old password: ${response.data['old_password'][0]}";
          } else if (response.data['new_password'] != null) {
            errorMessage = "New password: ${response.data['new_password'][0]}";
          }
          
          showErrorToast(errorMessage);
        }
      } catch (e) {
        showErrorToast('Failed to change password: $e');
      } finally {
        _isLoading.value = false;
      }
    }
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
          'Change Password',
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Password Form Container
                Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Color(0xff577AAE),
                  ),
                  child: Column(
                    children: [
                      _buildPasswordField(
                        controller: _oldPasswordController,
                        label: 'Old Password',
                        hintText: 'Enter your old password',
                        icon: Icons.lock_outline,
                        isObscure: _isOldPasswordObscure,
                        onToggleObscure: () {
                          setState(() {
                            _isOldPasswordObscure = !_isOldPasswordObscure;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildPasswordField(
                        controller: _newPasswordController,
                        label: 'New Password',
                        hintText: 'Enter your new password',
                        icon: Icons.lock_reset,
                        isObscure: _isNewPasswordObscure,
                        onToggleObscure: () {
                          setState(() {
                            _isNewPasswordObscure = !_isNewPasswordObscure;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: 'Confirm New Password',
                        hintText: 'Confirm your new password',
                        icon: Icons.lock_reset,
                        isObscure: _isConfirmPasswordObscure,
                        onToggleObscure: () {
                          setState(() {
                            _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                          });
                        },
                      ),
                      SizedBox(height: 30.h),
                      
                      // Change Password Button
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _isLoading.value ? null : _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff193670),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              side: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                          ),
                          child: _isLoading.value
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.h,
                                  child: CircularProgressIndicator(
                                    color: Color(0xffFFFFFF),
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text(
                                  'Change Password',
                                  style: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      )),
                    ],
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                // Password Requirements
                Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Color(0xff577AAE),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Requirements:',
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildRequirement('At least 8 characters long'),
                      _buildRequirement('Should not be similar to old password'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required bool isObscure,
    required VoidCallback onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xffFFFFFF),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          style: TextStyle(color: Color(0xffFFFFFF)),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: Color(0xffFFFFFF)),
            suffixIcon: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                isObscure ? Icons.visibility_off : Icons.visibility,
                color: Color(0xffFFFFFF),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            if (label.contains('New') && value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (label.contains('Confirm') && value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Color(0xff4CAF50),
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xff8E8E93),
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}