// views/notification_page.dart
import 'package:campus_connect/src/controller/notification_controller.dart';
import 'package:campus_connect/src/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController _controller = Get.find();

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff020826),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() => _controller.unreadCount > 0
              ? TextButton(
                  onPressed: _controller.markAllAsRead,
                  child: Text(
                    'Mark all read',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                )
              : SizedBox()),
        ],
      ),
      body: Container(
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
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Obx(() {
            final notifications = _controller.notifications;
            
            if (notifications.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationItem(
                  notification: notification,
                  onTap: () => _controller.markAsRead(notification.id),
                  onDelete: () => _controller.deleteNotification(notification.id),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80.sp,
            color: Colors.white.withValues(alpha:0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications yet',
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.7),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Notifications from your campus will appear here',
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.5),
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: notification.isRead 
                ? Color(0xff577AAE).withValues(alpha:0.3)
                : Color(0xff577AAE).withValues(alpha:0.6),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withValues(alpha:0.1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon based on type
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: _getIconColor(notification.type),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(notification.type),
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 12.w),
              
              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.body,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.8),
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a').format(notification.timestamp),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Unread indicator
              if (!notification.isRead) ...[
                SizedBox(width: 8.w),
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'message':
        return Icons.message;
      case 'announcement':
        return Icons.announcement;
      case 'event':
        return Icons.event;
      case 'alert':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String? type) {
    switch (type) {
      case 'message':
        return Colors.green;
      case 'announcement':
        return Colors.blue;
      case 'event':
        return Colors.purple;
      case 'alert':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}