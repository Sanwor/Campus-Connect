import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../app_utils/read_write.dart';

class EventContainer extends StatefulWidget {
  final String eventTitle;
  final String eventDate;
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
  });

  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 100.h,
          width: 300.w,
          color: Color(0xff577AAE), // Same blue color as notice container
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Event icon or image
                SizedBox(
                  width: 40.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                widget.imageUrl!,
                                width: 32.w,
                                height: 32.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return SvgPicture.asset(
                                    'assets/event.svg', // You can create this SVG
                                    width: 24.w,
                                    height: 24.h,
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SvgPicture.asset(
                                    'assets/event.svg',
                                    width: 24.w,
                                    height: 24.h,
                                  );
                                },
                              ),
                            )
                          : SvgPicture.asset(
                              'assets/event.svg', // Fallback to event icon
                              width: 24.w,
                              height: 24.h,
                            ),
                    ],
                  ),
                ),
                
                // Event details
                SizedBox(
                  height: 100.h,
                  width: 200.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Date and time
                      Text(
                        _formatDateTime(),
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      
                      // Event title
                      Text(
                        widget.eventTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      
                      // Location
                      Text(
                        widget.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xffE0E0E0),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Admin menu (only for admin users)
                read("isAdmin") == "true" 
                  ? PopupMenuButton(
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
                            Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
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
                            SizedBox(width: 8),
                            Text(
                              'Update',
                              style: TextStyle(color: Colors.lightBlue),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                  : SizedBox(width: 40.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime() {
    try {
      final date = DateFormat("yyyy-MM-dd").parse(widget.eventDate);
      final formattedDate = DateFormat("MMM dd, yyyy").format(date);
      
      // Format time (remove seconds if present)
      String startTime = widget.startTime.length > 5 
          ? widget.startTime.substring(0, 5) 
          : widget.startTime;
      String endTime = widget.endTime.length > 5 
          ? widget.endTime.substring(0, 5) 
          : widget.endTime;
      
      return '$formattedDate • $startTime - $endTime';
    } catch (e) {
      return '${widget.eventDate} • ${widget.startTime} - ${widget.endTime}';
    }
  }
}