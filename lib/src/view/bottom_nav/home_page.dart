import 'package:campus_connect/src/controller/auth_controller.dart';
import 'package:campus_connect/src/controller/chat_controller.dart';
import 'package:campus_connect/src/controller/notice_controller.dart';
import 'package:campus_connect/src/controller/profile_controller.dart';
import 'package:campus_connect/src/model/class_schedule.dart';
import 'package:campus_connect/src/view/bottom_nav/bottom_nav.dart';
import 'package:campus_connect/src/view/create_notice.dart';
import 'package:campus_connect/src/view/notice_details.dart';
import 'package:campus_connect/src/view/notification_page.dart';
import 'package:campus_connect/src/view/profile_page.dart';
import 'package:campus_connect/src/view/user_list.dart';
import 'package:campus_connect/src/widgets/custom_alerts.dart';
import 'package:campus_connect/src/widgets/notice_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app_utils/read_write.dart';

class HomePage extends StatefulWidget {
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profController = Get.find<ProfileController>();
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoticeController noticeCon = Get.put(NoticeController());

  bool isViewAll = false;
  String? getCurrentUser() {
  return read("userName"); 
}

String? getAccessToken() {
  return read("access_token");
}

bool isUserLoggedIn() {
  final token = read("access_token");
  return token != null && token.isNotEmpty;
}
  final String today = getTodayName();
  

  @override
  void initState() {
    super.initState();
    initialise();
  }

  initialise() {
    noticeCon.getNoticeList();
    widget.profController.getProfile();
  }

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
                if (read("isAdmin") == "true" ) {
                  Get.to(() => UsersPage()); // Navigate to Users list for admin
                } else {
                  Get.to(() => ProfilePage()); // Navigate to Profile for students
                }
              },
              icon: Icon(
                Icons.person,
                color: Color(0xffFFFFFF),
              ),
            ),
        ],
        leading: IconButton(onPressed: () => Get.to(() => NotificationPage()),
         icon: Icon(Icons.notifications),color: Colors.white,),
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

      body: RefreshIndicator(
        onRefresh: () {
          return noticeCon.getNoticeList();
        },
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
            padding: EdgeInsets.only(top: 5.sp, left: 30.sp, right: 30.sp),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx((){
                    final profile = widget.profController.profile.value;
                    final fullName = "${profile?.firstName ?? ''} ${profile?.lastName ?? ''}".trim();
                    return Row(
                      children: [
                        Text(
                          'Welcome! \n${read("isAdmin") != "true" ? fullName : "Admin"}.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    );
                  } 
                  ),
                  SizedBox(height: 20.h),
                  //shows today's day (might not need this)
                  // Text(
                  //   "$today's Schedule:",
                  //   style: TextStyle(
                  //       fontSize: 16.sp,
                  //       fontWeight: FontWeight.w600,
                  //       color: Color(0xffFFFFFF)),
                  // ),

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
                    child: schedule.containsKey(getTodayName())
                        ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: Colors.white.withValues(alpha: 0.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date Header
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: Text(
                                    '${getTodayName()}, ${DateFormat('MMMM d').format(DateTime.now())}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                // Schedule Items
                                ...schedule[getTodayName()]!.asMap().entries.map((entry) {
                                  final item = entry.value;
                                  final isLast = entry.key ==
                                      schedule[getTodayName()]!.length - 1;

                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10.h),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Time
                                            SizedBox(
                                              width: 120.w,
                                              child: Text(
                                                item['time']!,
                                                style: TextStyle(
                                                  color: Colors.white.withValues(alpha: 0.8),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),

                                            // Subject
                                            Expanded(
                                              child: Text(
                                                item['subject']!,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Divider (except last item)
                                      if (!isLast)
                                        Divider(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          thickness: 1,
                                          height: 4.h,
                                        ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(20.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: Color(0xff1E3D7A).withValues(alpha: 0.9),
                            ),
                            child: Text(
                              'No class schedule for today.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Text(
                        'Recent Notices',
                        style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffFFFFFF)),
                      ),
                      Spacer(),

                      // View All button
                      Visibility(
                        visible: notices.length > 3,
                        child: TextButton(
                          onPressed: () {
                            Get.offAll(() => BottomNavPage(
                                  initialIndex: 1,
                                ));
                          },
                          child: Text(
                            "View All",
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

                  Obx(
                    () => noticeCon.isNoticeLoading.isTrue
                        ? Padding(
                            padding: EdgeInsets.all(16.0.sp),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : noticeCon.noticeList.isEmpty
                            ? Padding(
                                padding: EdgeInsets.all(16.0.sp),
                                child: Center(
                                    child: Text(
                                  "Notice List is Empty",
                                  style: TextStyle(color: Colors.white),
                                )))
                            : Flexible(
                                fit: FlexFit.loose,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 10.h),
                                  padding:
                                      EdgeInsets.only(top: 20.h, bottom: 30.h),
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: noticeCon.noticeList.length >= 3
                                      ? 3
                                      : noticeCon.noticeList.length,
                                  itemBuilder: (context, index) {
                                    final notice = noticeCon.noticeList[index];
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: NoticeContainer(
                                        title: notice.title.toString(),
                                        dateTime: notice.publishedAt.toString(),
                                        onTap: () => Get.to(() => NoticeDetails(
                                              noticeid: noticeCon
                                                  .noticeList[index].id,
                                            )),
                                        onTapMenu: (value) async {
                                          if (value == 'delete') {
                                            showDialog(
                                                context: context,
                                                builder:(BuildContext context) {
                                                  return CustomAlert(
                                                    title: 'Delete',
                                                    content: 'Do you want to delete this notice?',
                                                    onTap: () async {
                                                      noticeCon.deleteNotice(noticeCon.noticeList[index].id);
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                });
                                          }
                                          //for update
                                          else {
                                            Get.to(() => CreateNotice(
                                                  isUpdate: true,
                                                  noticeid: noticeCon
                                                      .noticeList[index].id,
                                                ));
                                          }
                                        },
                                      ),
                                    );
                                  },
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
