import 'dart:io';

import 'package:campus_connect/src/app_utils/validations.dart';
import 'package:campus_connect/src/controller/notice_controller.dart';
import 'package:campus_connect/src/widgets/custom_network_image.dart';
import 'package:campus_connect/src/widgets/custom_textfield.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateNotice extends StatefulWidget {
  final bool? isUpdate;
  final int? noticeid;
  const CreateNotice({super.key, this.isUpdate, this.noticeid});

  @override
  State<CreateNotice> createState() => _CreateNoticeState();
}

class _CreateNoticeState extends State<CreateNotice> {
  final NoticeController noticeCon = Get.put(NoticeController());
  final _formKey = GlobalKey<FormState>();

  //text controllers
  final TextEditingController titleCon = TextEditingController();
  final TextEditingController detailsCon = TextEditingController();
  final TextEditingController contactCon = TextEditingController();

  dynamic selectedImage;

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
          widget.isUpdate == true ? 'Update Notice' : 'Create Notice',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                CustomTextFormField(
                  headingText: 'Title',
                  controller: titleCon,
                  validator: (value) => validateIsEmpty(string: value!),
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextFormField(
                  headingText: 'Details',
                  maxLines: 8,
                  controller: detailsCon,
                  validator: (value) => validateIsEmpty(string: value!),
                ),
                SizedBox(
                  height: 20.h,
                ),
                /////////////////////////////////////////////////////////////////

                Text(
                  'Upload an image*:',
                  style: TextStyle(fontSize: 12.h, color: Colors.white),
                ),
                SizedBox(height: 10.h),

                // Document Image Section
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: selectedImage == null
                      ? GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.r)),
                              ),
                              backgroundColor: Color(0xff020826),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  child: Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // shrink to fit content
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(100.w, 50.h),
                                            backgroundColor: Colors.transparent,
                                            iconColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final picked =
                                                await ImagePicker().pickImage(
                                              source: ImageSource.camera,
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                selectedImage =
                                                    File(picked.path);
                                              });
                                            }

                                            // Pop Bottom Sheet
                                            Get.back();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                  Icons.camera_alt_outlined),
                                              SizedBox(width: 20.w),
                                              Text(
                                                "Camera",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(100.w, 50.h),
                                            backgroundColor: Colors.transparent,
                                            iconColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final picked =
                                                await ImagePicker().pickImage(
                                              source: ImageSource.gallery,
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                selectedImage =
                                                    File(picked.path);
                                              });
                                            }
                                            // Pop Bottom Sheet
                                            Get.back();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.image_outlined),
                                              SizedBox(width: 20.w),
                                              Text(
                                                "Gallery",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 200.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white, // border color
                                width: 1, // border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  20.r), // rounded corners
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30.sp,
                                  ),
                                  Text(
                                    'Tap to add image',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ))
                      : Stack(
                          children: [
                            // Image
                            selectedImage.runtimeType.toString() == "_File"
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.file(
                                      selectedImage,
                                      height: 240.h,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      frameBuilder: (BuildContext context,
                                          Widget child,
                                          int? frame,
                                          bool wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child; // Image loaded instantly
                                        }
                                        return AnimatedOpacity(
                                          opacity: frame == null ? 0 : 1,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: frame == null
                                              ? Container(
                                                  color: Colors.grey[300],
                                                  height: 240.h,
                                                  width: double.infinity,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              : child,
                                        );
                                      },
                                    ),
                                  )
                                : CustomDisplayNetworkImage(
                                    borderRadius: BorderRadius.circular(8.r),
                                    url: selectedImage,
                                    height: 240.h,
                                    width: double.infinity,
                                    boxFit: BoxFit.contain,
                                  ),

                            // Delete Image BUtton
                            if (selectedImage != null)
                              Positioned(
                                  right: 10,
                                  top: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImage = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                          6), // spacing inside circle
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors
                                                .black12, // soft black shadow
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.clear,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                          ],
                        ),
                ),

                SizedBox(height: 30.h),

                Obx(() => SizedBox(
                      width: 260.w,
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff193670),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0.r),
                            side: BorderSide(
                              color: Colors.white,
                              width: 2.w,
                            ),
                          ),
                        ),
                        onPressed: noticeCon.isNoticePostLoading.value
                            ? null // disable when submitting
                            : () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                var isValid = _formKey.currentState!.validate();
                                if (!isValid) return;
                                if (selectedImage == null) {
                                  Get.snackbar(
                                      "Please add image",
                                      colorText: Colors.white,
                                      '',
                                      duration: Duration(seconds: 2));
                                  return;
                                }
                                noticeCon.postNotice(
                                  title: titleCon.text,
                                  details: detailsCon.text,
                                  noticeImage: selectedImage,
                                );
                              },
                        child: noticeCon.isNoticePostLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                'Submit',
                                style: TextStyle(
                                  color: const Color(0xffFFFFFF),
                                  fontSize: 16.sp,
                                ),
                              ),
                      ),
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
