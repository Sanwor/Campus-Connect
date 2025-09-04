import 'package:campus_connect/src/controller/notice_controller.dart';
import 'package:campus_connect/src/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoticeDetails extends StatefulWidget {
  final int noticeid;
  const NoticeDetails({super.key, required this.noticeid});

  @override
  State<NoticeDetails> createState() => _NoticeDetailsState();
}

class _NoticeDetailsState extends State<NoticeDetails> {
  final NoticeController noticeCon = Get.put(NoticeController());

  @override
  void initState() {
    super.initState();
    initialise();
  }

  initialise() async {
    await noticeCon.getNoticeDetails(widget.noticeid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Notice',
              style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFFFFFF)),
            ),
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: const Color(0xffFFFFFF),
                ))),
        body: Container(
          padding: EdgeInsets.only(top: 80.sp),
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
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 36.h, left: 30.w, right: 30.w, bottom: 20.sp),
                    child: noticeCon.isNoticeDetailsLoading.isTrue
                        ? Padding(
                            padding: EdgeInsets.all(16.0.sp),
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: [
                              Text(
                                noticeCon.noticeDetails.title,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.h),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    noticeCon.noticeDetails.publishedAt
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.h),
                                  ),
                                ],
                              ),
                              SizedBox(height: 50.h),
                              Text(
                                noticeCon.noticeDetails.content,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.h),
                              ),
                              SizedBox(height: 20.h),
                              CustomDisplayNetworkImage(
                                  url: noticeCon.noticeDetails.content,
                                  height: 500.h,
                                  width: double.infinity)
                            ],
                          ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
