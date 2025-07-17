import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [SvgPicture.asset('assets/bell.svg')],
                  ),
                ),
                SizedBox(
                  height: 100.h,
                  width: 250.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateTime,
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        title,
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
      ),
    );
  }
}
