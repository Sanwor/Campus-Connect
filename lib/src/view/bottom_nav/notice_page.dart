import 'package:campus_connect/src/controller/auth_controller.dart';
import 'package:campus_connect/src/controller/notice_controller.dart';
import 'package:campus_connect/src/view/create_notice.dart';
import 'package:campus_connect/src/view/notice_details.dart';
import 'package:campus_connect/src/widgets/custom_alerts.dart';
import 'package:campus_connect/src/widgets/notice_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../app_utils/read_write.dart';

class NoticePage extends StatefulWidget {
  final AuthController authController = Get.find<AuthController>();
  NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final NoticeController noticeCon = Get.put(NoticeController());
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialise();
  }

  initialise() async {
    await noticeCon.getNoticeList();
  }

  void _onSearchChanged(String query) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Notices',
          style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF)),
        ),
        actions: [
          read("isAdmin") == "true" 
            ?IconButton(
            onPressed: () {
              Get.to(() => CreateNotice(
                    isUpdate: false,
                  ));
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            )): SizedBox(width: 40.w), 
        ],
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () {
            return noticeCon.getNoticeList();
          },
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(top: 120.sp, left: 30.w, right: 30.w),
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
                child: noticeCon.isNoticeLoading.isTrue
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
                        : Column(
                            children: [

                              // Search bar
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: _onSearchChanged,
                                    decoration: InputDecoration(
                                      hintText: "Search notices...",
                                      hintStyle: TextStyle(
                                        color: Colors.white
                                      ),
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                    ),
                                  ),
                                ),
                              ),


                              // List of notices
                              if (noticeCon.noticeList.isNotEmpty)
                                ListView.separated(
                                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                                  padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: noticeCon.noticeList.length,
                                  itemBuilder: (context, index) {
                                    final notice = noticeCon.noticeList[index];
                                    final query = searchController.text.trim().toLowerCase();
                                    final matches = query.isEmpty ||
                                    (notice.title?.toLowerCase().contains(query) ?? false);
                                
                                    if (!matches) {
                                      return SizedBox.shrink(); // hide non-matching items
                                    }
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: NoticeContainer(
                                        title: notice.title.toString(),
                                        dateTime: notice.publishedAt.toString(),
                                        onTap: () =>
                                          Get.to(() => NoticeDetails(
                                            noticeid: noticeCon.noticeList[index].id,
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
                                                      Get.back();
                                                      noticeCon.getNoticeList();
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
                            ],
                          )),
          ),
        ),
      ),
    );
  }
}
