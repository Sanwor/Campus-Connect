import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../controller/notification_controller.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission (important for iOS)
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages - THIS IS CRITICAL
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('📱 Foreground FCM message received: ${message.data}');
      
      // Convert FCM message to app notification
      _handleForegroundMessage(message);
    });

    // Handle when app is opened from background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('📱 App opened from FCM: ${message.data}');
      _handleNotificationTap(message.data);
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final NotificationController notificationController = Get.find();
    
    String title = message.notification?.title ?? 'New Notification';
    String body = message.notification?.body ?? '';
    
    // If no notification title/body, try to get from data
    if (title == 'New Notification' && message.data['title'] != null) {
      title = message.data['title'];
    }
    if (body.isEmpty && message.data['body'] != null) {
      body = message.data['body'];
    }

    notificationController.addNotification(
      title: title,
      body: body,
      type: message.data['type'] ?? 'announcement',
      data: message.data,
    );
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final String? type = data['type'];
    final String? noticeId = data['notice_id'];
    
    if (type == 'announcement' && noticeId != null) {
      // Navigate to notice details
      Get.toNamed('/notice/$noticeId');
    }
    // Add more navigation handlers as needed
  }

  // Get FCM token (you're already doing this in login)
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }
}