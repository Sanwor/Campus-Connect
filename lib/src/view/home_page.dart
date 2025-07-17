import 'package:campus_connect/src/controller/chat_controller.dart';
import 'package:campus_connect/src/model/class_schedule.dart';
import 'package:campus_connect/src/view/profile_page.dart';
import 'package:campus_connect/src/widgets/notice_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isViewAll = false;
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
                  "$today's Schedule:",
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

                Row(
                  children: [
                    Spacer(),

                    // View All button
                    Visibility(
                      visible: notices.length > 3,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isViewAll = !isViewAll;
                          });
                        },
                        child: Text(
                          isViewAll ? "View Less" : "View All",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // List of notices
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: isViewAll
                        ? notices.length
                        : (notices.length > 3 ? 3 : notices.length),
                    itemBuilder: (context, index) {
                      final notice = notices[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16.sp),
                        child: NoticeContainer(
                          title: notice['title'].toString(),
                          dateTime: notice['date'].toString(),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
