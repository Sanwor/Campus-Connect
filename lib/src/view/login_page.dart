import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/app_utils/validations.dart';
import 'package:campus_connect/src/controller/auth_controller.dart';
import 'package:campus_connect/src/view/bottom_nav.dart';
import 'package:campus_connect/src/view/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isObscure = true;
  // final authController = Get.put(AuthController()); //old controller
  // Get the controller
  final AuthController authController = Get.find();

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());

    write('isLoggedIn', 'LoggedIn');
    Get.off(() => BottomNavPage(initialIndex: 0));
    Get.snackbar('User verified!', 'logged in successfully',
        animationDuration: Duration(milliseconds: 500),
        colorText: Color(0xffFFFFFF));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      fontSize: 12.h,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20.h),

                  //login container
                  Form(
                    key: formKey,
                    child: SizedBox(
                      height: 360.h,
                      width: 300.w,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10.sp, right: 10.sp, top: 10.sp),
                        child: Column(
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffFFFFFF),
                              ),
                            ),

                            SizedBox(height: 30.h),

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
                              obscureText: isObscure,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isObscure = !isObscure;
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      isObscure
                                          ? 'assets/hide_post_icon.svg'
                                          : 'assets/eye_outlined.svg',
                                      colorFilter: ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                  ),
                                  hintText: 'Enter your password',
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),

                            SizedBox(height: 10.sp),

                            //forgot password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Color(0xffFFFFFF)),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    ' Reset',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Color(0xffFFFFFF),
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),

                            SizedBox(height: 30.h),

                            //login button
                            Obx(() => SizedBox(
                                  width: 260.w,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff193670),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onPressed: authController.isLoginLoading.value
                                        ? null // disable while loading
                                        : () async {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          var isValid = formKey.currentState!.validate();
                                          if (!isValid) return;

                                          authController.isLoginLoading.value = true;
                                          await authController.login(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                                          },
                                    child: authController.isLoginLoading.value
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            'Login',
                                            style: TextStyle(
                                              color: const Color(0xffFFFFFF),
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not registered yet? ',
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => RegisterPage()),
                        child: Text(
                          'Register now.',
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  //google login
                  // IconButton(
                  //     onPressed: () {},
                  //     icon: SvgPicture.asset(
                  //       'assets/loginGoogle.svg',
                  //       height: 50.h,
                  //       width: 50.w,
                  //     ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
