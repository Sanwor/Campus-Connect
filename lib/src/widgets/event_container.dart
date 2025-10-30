import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../app_utils/read_write.dart';

class EventContainer extends StatefulWidget {
  final String eventTitle;
  final String eventDate;
  final String eventDetail;
  final String startTime;
  final String endTime;
  final String location;
  final String? imageUrl;
  final VoidCallback onTap;
  final PopupMenuItemSelected<dynamic> onTapMenu;

  const EventContainer({
    super.key,
    required this.eventTitle,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.imageUrl,
    required this.onTap,
    required this.onTapMenu, 
    required this.eventDetail,
  });

  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======= IMAGE =======
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                  ? Image.network(
                      widget.imageUrl!,
                      width: double.infinity,
                      height: 160.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160.h,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/event.svg',
                            height: 40.h,
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 160.h,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/event.svg',
                        height: 40.h,
                      ),
                    ),
            ),

            // ======= EVENT INFO =======
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Category badge + Menu (admin)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.eventTitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      if (read("isAdmin") == "true")
                        PopupMenuButton(
                          color: Colors.white,
                          onSelected: widget.onTapMenu,
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline_outlined,
                                      color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'update',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined,
                                      color: Colors.blueAccent),
                                  SizedBox(width: 8),
                                  Text('Update',
                                      style:
                                          TextStyle(color: Colors.blueAccent)),
                                ],
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Date & time
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 14.sp, color: Colors.white),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDateTime(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14.sp, color: Colors.white),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          widget.location,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Description or detail snippet (if you later have one)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold
                        )),
                      Text(
                        widget.eventDetail,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime() {
    try {
      final date = DateFormat("yyyy-MM-dd").parse(widget.eventDate);
      final formattedDate = DateFormat("EEE, MMM d").format(date);
      String startTime = widget.startTime.length > 5
          ? widget.startTime.substring(0, 5)
          : widget.startTime;
      return "$formattedDate • $startTime";
    } catch (e) {
      return '${widget.eventDate} • ${widget.startTime}';
    }
  }
}
