import 'package:campus_connect/src/model/class_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Routines',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100.sp, left: 16.w, right: 16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff020826),
              Color(0xff204486),
            ],
          ),
        ),
        child: ListView.builder(
  padding: EdgeInsets.only(bottom: 50.h),
  itemCount: classDays.length + 1, // +1 for the header text
  itemBuilder: (context, index) {
    if (index == 0) {
      // info text 
      return Padding(
        padding: EdgeInsets.only(bottom: 50.h),
        child: Text(
          "Following are the weekly class schedule for BIT 7th semester students:",
          style: TextStyle(
            color: Colors.white.withValues(alpha:0.9),
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.start,
        ),
      );
    }

    //routines in expansion tile
    String day = classDays[index - 1];
    List<Map<String, String>> daySchedule = schedule[day]!;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          backgroundColor: Colors.white.withValues(alpha:0.15),
          collapsedBackgroundColor: Colors.white.withValues(alpha:0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: Text(
            day,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          childrenPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white.withValues(alpha:0.15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.2),
                    blurRadius: 10.r,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      day == getTodayName()
                          ? '${getTodayName()}, ${DateFormat('MMMM d').format(DateTime.now())}'
                          : day,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.9),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  ...daySchedule.asMap().entries.map((entry) {
                    final item = entry.value;
                    final isLast = entry.key == daySchedule.length - 1;

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120.w,
                                child: Text(
                                  item['time']!,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha:0.8),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
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
                        if (!isLast)
                          Divider(
                            color: Colors.white.withValues(alpha:0.2),
                            thickness: 1,
                            height: 4.h,
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
)
),
    );
  }
}
