import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeContainer extends StatelessWidget {
  final String title;
  final String dateTime;
  final VoidCallback onTap;
  const NoticeContainer(
      {super.key,
      required this.title,
      required this.dateTime,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.sp),
        child: Container(
          height: 100,
          width: 300,
          color: Color(0xff577AAE),
          child: Column(),
        ),
      ),
    );
  }
}
