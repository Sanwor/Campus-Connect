import 'package:campus_connect/src/controller/notice_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NoticeContainer extends StatefulWidget {
  final String title;
  final String dateTime;
  final VoidCallback onTap;
  final PopupMenuItemSelected<dynamic> onTapMenu;
  const NoticeContainer(
      {super.key,
      required this.title,
      required this.dateTime,
      required this.onTap,
      required this.onTapMenu});

  @override
  State<NoticeContainer> createState() => _NoticeContainerState();
}

class _NoticeContainerState extends State<NoticeContainer> {
  final NoticeController noticeCon = Get.put(NoticeController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            height: 100.h,
            width: 300.w,
            color: Color(0xff577AAE),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                SizedBox(
                  width: 40.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [SvgPicture.asset('assets/bell.svg')],
                  ),
                ),
                SizedBox(
                  height: 100.h,
                  width: 240.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat("yyyy-MM-dd")
                            .format(DateTime.parse(widget.dateTime)),
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                PopupMenuButton(
                  color: Colors.white,
                  onSelected: widget.onTapMenu,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'update',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.lightBlue,
                          ),
                          Text(
                            'Update',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}
