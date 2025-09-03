import 'package:campus_connect/src/controller/notice_controller.dart';
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
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 36.h, left: 30.w, right: 30.w),
            child: Column(
              children: [
                Text(noticeCon.noticeDetails.title),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
