import 'package:campus_connect/src/view/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),

                  //login container
                  SizedBox(
                    height: 470.h,
                    width: 300.w,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20.sp, right: 20.sp, top: 10.sp),
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
                            cursorColor: Color(0xffFFFFFF),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This is a required field";
                              }

                              if (value.length > 255) {
                                return "Only 3 Characters can be Entered";
                              }
                              return null;
                            },
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "The password can't be empty";
                              }
                              if (value.length < 8) {
                                return "Password must be greater than 8 characters";
                              }
                              return null;
                            },
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
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
                                    fontSize: 12.sp, color: Color(0xffFFFFFF)),
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
                          SizedBox(
                              width: 260.w,
                              height: 40.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff193670),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                      color: Colors.white, // 👈 white border
                                      width: 2, // optional: border width
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Get.off(() => BottomNavPage(initialIndex: 0));
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 16.sp),
                                ),
                              )),

                          SizedBox(height: 20.h),

                          Text(
                            'or Continue with:',
                            style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),

                          SizedBox(height: 20.h),

                          //google login
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
