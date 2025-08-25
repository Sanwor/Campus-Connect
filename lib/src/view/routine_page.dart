import 'package:campus_connect/src/model/class_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              color: Color(0xffFFFFFF)),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 50.sp),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: 20.h,
                      ),
                      itemCount: classDays.length,
                      itemBuilder: (context, index) {
                        String day = classDays[index];
                        List<Map<String, String>> daySchedule = schedule[day]!;

                        return ExpansionTile(
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          backgroundColor: Color(0xff577AAE),
                          title: Text(
                            day,
                            style: TextStyle(color: Color(0xffFFFFFF)),
                          ),
                          children: [
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(2.w),
                                1: FlexColumnWidth(3.w),
                              },
                              border: TableBorder.all(color: Color(0xffFFFFFF)),
                              children: daySchedule.map((entry) {
                                return TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.sp),
                                    child: Text(
                                      entry['time']!,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: Color(0xffFFFFFF)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.sp),
                                    child: Text(entry['subject']!,
                                        style:
                                            TextStyle(color: Color(0xffFFFFFF)),
                                        textAlign: TextAlign.center),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    )),
              ],
            ),
          )),
    );
  }
}
