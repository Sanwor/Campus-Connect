import 'package:campus_connect/src/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EventDetailPage extends StatelessWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff020826), Color(0xff204486)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Cover Image
              Stack(
                children: [
                  Container(
                    height: 250.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: event.image != null
                            ? NetworkImage(event.image!)
                            : const AssetImage('assets/event_placeholder.jpg')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 250.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    child: Text(
                      event.eventTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Event Info Card
              Padding(
                padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 20.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Event Details:",style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp
                    ),),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(Icons.calendar_month, "Date", event.eventDate),
                    _divider(),
                    _infoRow(Icons.access_time, "Time",
                        "${event.startTime} - ${event.endTime}"),
                    _divider(),
                    _infoRow(Icons.location_on, "Location", event.location),
                    _divider(),
                    _infoRow(Icons.description, "Details", event.eventDetail),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400)),
                SizedBox(height: 4.h),
                Text(value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.white.withValues(alpha: 0.3), height: 10.h);
  }
}
