import 'package:campus_connect/src/app_utils/validations.dart';
import 'package:campus_connect/src/view/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isObscure1 = true;
  bool isObscure2 = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      Get.off(() => BottomNavPage(initialIndex: 0));
    } else {
      Get.snackbar('Invalid', "The password doesn't match",
          colorText: Color(0xffFFFFFF));
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
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
      body: SingleChildScrollView(
        child: Center(
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
                      height: 392.h,
                      width: 300.w,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20.sp, right: 20.sp, top: 10.sp),
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

                            //email
                            TextFormField(
                              controller: _emailController,
                              cursorColor: Color(0xffFFFFFF),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (email) =>
                                  validateEmail(string: email!),
                              style: TextStyle(color: Color(0xffFFFFFF)),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: 'Enter you email',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 14.sp),
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (password) =>
                                  validatePassword(string: password!),
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
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 14.sp),
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (confirmPassword) =>
                                  validateConfirmPassword(
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
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 14.sp),
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),

                            SizedBox(height: 20.h),

                            //Signup button
                            SizedBox(
                                width: 260.w,
                                height: 50.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff193670),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                        color: Colors.white,
                                        width: 2, // optional: border width
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var isValid =
                                        formKey.currentState!.validate();
                                    if (isValid == false) {
                                      return;
                                    } else {
                                      signUp();
                                    }
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 16.sp),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Text(
                    'Not registered yet? ',
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 10.h),

                  // google login
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/loginGoogle.svg',
                        height: 50.h,
                        width: 50.w,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
