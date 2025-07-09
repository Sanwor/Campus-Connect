import 'package:campus_connect/src/controller/chat_controller.dart';
import 'package:campus_connect/src/model/class_schedule.dart';
import 'package:campus_connect/src/view/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final String today = getTodayName();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Color(0xff020826),
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => ProfilePage());
              },
              icon: Icon(
                Icons.person,
                color: Color(0xffFFFFFF),
              ))
        ],
      ),

      //chat bot
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Full screen height if needed
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => ChatBottomSheet(),
          );
        },
        child: Icon(Icons.chat),
      ),

      body: Container(
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
          padding: EdgeInsets.only(top: 5.sp, left: 30.sp, right: 30.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Welcome!\nto Campus Connect',
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  "Today's Schedule:",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF)),
                ),

                SizedBox(height: 10.h),

                //today's schedule
                // Text(
                //   today,
                //   style: TextStyle(
                //       fontSize: 16.sp,
                //       fontWeight: FontWeight.w600,
                //       color: Color(0xffFFFFFF)),
                //   textAlign: TextAlign.left,
                // ),
                Center(
                  child: schedule.containsKey(today)
                      ? Table(
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(3),
                          },
                          border: TableBorder.all(color: Color(0xffFFFFFF)),
                          children: schedule[today]!.map((entry) {
                            return TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  entry['time']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xffFFFFFF)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  entry['subject']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xffFFFFFF)),
                                ),
                              ),
                            ]);
                          }).toList(),
                        )
                      : Text(
                          'No class schedule for today.',
                          style: TextStyle(color: Colors.white),
                        ),
                ),

                SizedBox(height: 20.h),
                Text(
                  'Recent Notices',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF)),
                ),

                //recent notices
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
                      shrinkWrap: true,
                      itemCount: 5,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16.sp),
                          child: Container(
                            height: 100.h,
                            width: 320.w,
                            color: Color(0xff577AAE),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/bell.svg')
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100.h,
                                    width: 250.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'May 12',
                                          style: TextStyle(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          'BIT 5th Semester - 2079 Exam Notice',
                                          style: TextStyle(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
