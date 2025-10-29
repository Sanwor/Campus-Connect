import 'dart:io';

import 'package:campus_connect/src/app_utils/validations.dart';
import 'package:campus_connect/src/controller/auth_controller.dart';
import 'package:campus_connect/src/widgets/custom_datepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final AuthController authController = Get.put(AuthController()); // old controller
  final AuthController authController = Get.find();

  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _semesterController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _shiftController = TextEditingController();
  final _progController = TextEditingController();
  final _contController = TextEditingController();

  bool isObscure1 = true;
  bool isObscure2 = true;
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _rollNoController.dispose();
    _semesterController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _shiftController.dispose();
    _contController.dispose();
    _progController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image',
          colorText: Color(0xffFFFFFF),
          backgroundColor: Colors.red);
    }
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!passwordConfirmed()) {
      Get.snackbar('Invalid', "The password doesn't match",
          colorText: Color(0xffFFFFFF),
          backgroundColor: Colors.red);
      return;
    }

    if (_shiftController.text.trim().toLowerCase() != 'morning' && 
        _shiftController.text.trim().toLowerCase() != 'day') {
      Get.snackbar('Invalid', "Shift must be either 'morning' or 'day'",
          colorText: Color(0xffFFFFFF),
          backgroundColor: Colors.red);
      return;
    }

    // Call the register method from AuthController
    await authController.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      password2: _confirmPasswordController.text.trim(),
      firstName: _fnameController.text.trim(),
      lastName: _lnameController.text.trim(),
      rollNo: _rollNoController.text.trim(),
      semester: _semesterController.text.trim(),
      dob: _dobController.text.trim(), // Format: YYYY-MM-DD (BS)
      address: _addressController.text.trim(),
      shift: _shiftController.text.trim(),
      prog: _shiftController.text.trim(),
      contact: _contController.text.trim(),
      imagePath: _selectedImagePath,
    );
  }

  bool passwordConfirmed() {
    return _passwordController.text.trim() == _confirmPasswordController.text.trim();
  }

  String? validateShift(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter shift';
    }
    if (value.toLowerCase() != 'morning' && value.toLowerCase() != 'day') {
      return 'Shift must be either "morning" or "day"';
    }
    return null;
  }

  String? validateDob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter date of birth';
    }
    // // Basic validation for BS date format YYYYMMDD
    // if (value.length != 8 || !RegExp(r'^\d+$').hasMatch(value)) {
    //   return 'Please enter in YYYYMMDD format (BS)';
    // }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xffFFFFFF),
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
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
            padding: EdgeInsets.only(left: 30.sp, right: 30.sp, top: 102.sp),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // main logo
                  Image.asset(
                    'assets/mainlogo.png',
                  ),
                  SizedBox(height: 20.h),
              
                  //app details text
                   Text(
                    'CampusConnect is an app that enhances communication and information accessibility\nwithin the college.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
              
                  SizedBox(height: 20),
              
                  //login container
                  Form(
                    key: formKey,
                    child: SizedBox(
                      width: 300.w,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.sp),
                        child: Column(
                          children: [
                            Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffFFFFFF),
                              ),
                            ),
              
                            SizedBox(height: 20.h),
              
                           // Profile Image Picker
                          Column(
                            children: [
                              Text(
                                'Profile Image',
                                style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8.h),

                              //profile image - Vertical layout
                              Column(
                                children: [
                                  // Image display
                                  _selectedImagePath != null 
                                      ? Container(
                                          width: 150.w,
                                          height: 150.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: ClipOval(
                                            child: Image.file(
                                              File(_selectedImagePath!),
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey,
                                                  ),
                                                  child: Icon(Icons.error, color: Colors.white, size: 30.sp),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 100.w,
                                          height: 100.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                            color: Colors.grey.withValues(alpha:0.3),
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 40.sp,
                                          ),
                                        ),
                                  
                                  SizedBox(height: 15.h),
                                  
                                  // Choose file button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff193670),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    onPressed: _pickImage,
                                    child: Text(
                                      'Choose File',
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                            
                            //first Name
                            TextFormField(
                              controller: _fnameController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (name) => validateRequired(string: name!, field: 'First Name'),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              decoration: InputDecoration(
                                  hintText: 'Enter your First name',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),

                            //last name
                            SizedBox(height: 10.h),
                            TextFormField(
                              controller: _lnameController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (name) => validateRequired(string: name!, field: 'Last Name'),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              decoration: InputDecoration(
                                  hintText: 'Enter your Last name',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
              
                            SizedBox(height: 10.h),
              
                            // Roll No
                            TextFormField(
                              controller: _rollNoController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (rollNo) => validateRequired(string: rollNo!, field: 'Roll no'),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              decoration: InputDecoration(
                                  hintText: 'Enter your roll number',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'Roll no',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
              
                            SizedBox(height: 10.h),
              
                            // Semester
                            TextFormField(
                              controller: _semesterController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (semester) => validateRequired(string: semester!, field: 'Semester'),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: 'Enter your semester',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'Semester',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
              
                            SizedBox(height: 20.h),
              
                            // Date of Birth (BS)
                            CustomDatepicker(controller: _dobController,
                              labelText: 'Date of Birth',
                              firstDate: DateTime(1900, 1, 1),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            // TextFormField(
                            //   controller: _dobController,
                            //   cursorColor: Color(0xffFFFFFF),
                            //   autovalidateMode: AutovalidateMode.onUserInteraction,
                            //   validator: validateDob,
                            //   style: TextStyle(color: Color(0xffFFFFFF)),
                            //   keyboardType: TextInputType.name,
                            //   decoration: InputDecoration(
                            //       hintText: 'YYYYMMDD (BS)',
                            //       hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                            //       labelText: 'Date of Birth (BS)',
                            //       labelStyle: TextStyle(
                            //         color: Color(0xffFFFFFF),
                            //         fontSize: 15.sp,
                            //         fontWeight: FontWeight.w500,
                            //       )),
                            // ),
              
                            SizedBox(height: 10.h),
              
                            // Address
                            TextFormField(
                              controller: _addressController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (address) => validateRequired(string: address!, field: 'Address'),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              decoration: InputDecoration(
                                  hintText: 'Enter your address',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'Address',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
              
                            SizedBox(height: 10.h),
              
                            // Shift
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shift',
                                  style: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0.r),
                                    border: Border.all(color: Colors.white, width: 1.sp),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: _shiftController.text.isNotEmpty ? _shiftController.text : null,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'morning',
                                        child: Text(
                                          'Morning',
                                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'day',
                                        child: Text(
                                          'Day',
                                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                        ),
                                      ),
                                    ],
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        _shiftController.text = value;
                                      }
                                    },
                                    dropdownColor: Color(0xff193670),
                                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.0.sp),
                                      hintText: 'Select shift',
                                      hintStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
                                    ),
                                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                    validator: validateShift,
                                  ),
                                ),
                              ],
                            ),
              
                            SizedBox(height: 10.h),
              
                            //email
                            TextFormField(
                              controller: _emailController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (email) => validateEmail(string: email!),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'Email address',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
              
                            SizedBox(height: 10.h),
              
                            //password
                            TextFormField(
                              controller: _passwordController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (password) => validatePassword(string: password!),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              obscureText: isObscure1,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isObscure1 = !isObscure1;
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      isObscure1
                                          ? 'assets/hide_post_icon.svg'
                                          : 'assets/eye_outlined.svg',
                                      colorFilter: ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                  ),
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
              
                            SizedBox(height: 10.h),
              
                            //confirm password
                            TextFormField(
                              controller: _confirmPasswordController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (confirmPassword) => validateConfirmPassword(
                                  password: _passwordController.text,
                                  confirmPassword: confirmPassword!),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              obscureText: isObscure2,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isObscure2 = !isObscure2;
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      isObscure2
                                          ? 'assets/hide_post_icon.svg'
                                          : 'assets/eye_outlined.svg',
                                      colorFilter: ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                  ),
                                  hintText: 'Confirm your password',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
              
                             // program
                            SizedBox(height: 10.h),
                            TextFormField(
                              controller: _progController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (name) => validateRequired(string: name!, field: 'Program'),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              decoration: InputDecoration(
                                  hintText: 'Program',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'program',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                    
                             //Contact no
                            SizedBox(height: 10.h),
                            TextFormField(
                              controller: _contController,
                              keyboardType: TextInputType.phone
                              ,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (name) => validateRequired(string: name!, field: 'Contact'),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              decoration: InputDecoration(
                                  hintText: 'Enter your contact number',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'Contact Number',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
              

                            SizedBox(height: 20.h),
              
                            //Signup button
                            Obx(() => SizedBox(
                            width: 260.w,
                            height: 50.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff193670),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onPressed: authController.isRegisterLoading.value
                                  ? null // disable while loading
                                  : () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      var isValid = formKey.currentState!.validate();
                                      if (!isValid) return;

                                      authController.isRegisterLoading.value = true;
                                      await authController.register(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        password2: _confirmPasswordController.text,
                                        firstName: _fnameController.text,
                                        lastName: _lnameController.text,
                                        rollNo: _rollNoController.text,
                                        semester: _semesterController.text,
                                        dob: _dobController.text, // Format: YYYY-MM-DD (BS)
                                        address: _addressController.text,
                                        shift: _shiftController.text,
                                        contact: _contController.text,
                                        prog: _progController.text,
                                        imagePath: _selectedImagePath,
                                      );
                                    },
                              child: authController.isRegisterLoading.value
                                  ? SizedBox(
                                      width: 22.w,
                                      height: 22.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: const Color(0xffFFFFFF),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                            ),
                          ))],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Color(0xff4CAF50),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}