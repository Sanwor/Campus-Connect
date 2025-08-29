import 'package:campus_connect/src/controller/notice_controller.dart';
import 'package:campus_connect/src/view/notice_details.dart';
import 'package:campus_connect/src/widgets/notice_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final NoticeController noticeCon = Get.put(NoticeController());
  @override
  void initState() {
    super.initState();
    initialise();
  }

  initialise() async {
    await noticeCon.getNoticeList();
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
      ),
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
              // List of notices
              if (noticeCon.noticeList.isNotEmpty)
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                    padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: noticeCon.noticeList.length,
                    itemBuilder: (context, index) {
                      final notice = noticeCon.noticeList[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: NoticeContainer(
                          title: notice.title.toString(),
                          dateTime: notice.publishedAt.toString(),
                          onTap: () => Get.to(() => NoticeDetails(
                                noticeid: noticeCon.noticeList[index].id,
                              )),
                        ),
                      );
                    },
                  ),
                ),
            ],
          )),
    );
  }
}
