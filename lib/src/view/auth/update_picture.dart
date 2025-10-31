import 'dart:io';
import 'package:campus_connect/src/controller/profile_controller.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilePicturePage extends StatefulWidget {
  const UpdateProfilePicturePage({super.key});

  @override
  State<UpdateProfilePicturePage> createState() => _UpdateProfilePicturePageState();
}

class _UpdateProfilePicturePageState extends State<UpdateProfilePicturePage> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final _isLoading = false.obs;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      showErrorToast('Failed to pick image: $e');
    }
  }

  Future<void> _updateProfilePicture() async {
    if (_selectedImage == null) {
      showErrorToast('Please select an image first');
      return;
    }

    _isLoading.value = true;
    
    try {
      await _profileController.updateProfilePicture(_selectedImage!);
      Get.back();
      showToast('Profile picture updated successfully');
    } catch (e) {
      showErrorToast('Failed to update profile picture: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
        ),
        title: Text(
          'Update Profile Picture',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff020826),
              Color(0xff204486),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                
                // Current Profile Picture Section
                Text(
                  'Current Picture',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                
                Obx(() {
                  final profile = _profileController.profile.value;
                  return CircleAvatar(
                    radius: 60.sp,
                    backgroundColor: Color(0xff577AAE).withValues(alpha:0.3),
                    backgroundImage: profile?.image != null 
                        ? NetworkImage(profile!.image!) as ImageProvider
                        : AssetImage('assets/profile.png'),
                  );
                }),
                
                SizedBox(height: 40.h),
                
                // New Profile Picture Section
                Text(
                  'New Picture',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Image Preview Container
                Container(
                  width: 120.sp,
                  height: 120.sp,
                  decoration: BoxDecoration(
                    color: Color(0xff577AAE).withValues(alpha:0.3),
                    borderRadius: BorderRadius.circular(60.sp),
                    border: Border.all(
                      color: Colors.white.withValues(alpha:0.5),
                      width: 2,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60.sp),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 120.sp,
                            height: 120.sp,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt_outlined,
                          size: 40.sp,
                          color: Colors.white.withValues(alpha:0.7),
                        ),
                ),
                
                SizedBox(height: 24.h),
                
                // Select Image Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff577AAE).withValues(alpha:0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha:0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library, 
                            color: Colors.white, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Choose from Gallery',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                Spacer(),
                
                // Update Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _isLoading.value || _selectedImage == null 
                        ? null 
                        : _updateProfilePicture,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedImage != null 
                          ? Color(0xff4CAF50) 
                          : Colors.grey.withValues(alpha:0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading.value
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : Text(
                            'Update Picture',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}