import 'package:get/get.dart';
import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/model/notification_model.dart';

class NotificationController extends GetxController {
  final RxList<AppNotification> _notifications = <AppNotification>[].obs;
  final String _storageKey = 'notifications';

  List<AppNotification> get notifications => _notifications.toList()
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  // Load notifications from local storage
  void _loadNotifications() {
    try {
      final stored = read(_storageKey);
      if (stored != null && stored is String) {
        final List<dynamic> jsonList = stored is String ? (stored as dynamic) : [];
        _notifications.assignAll(
          jsonList.map((json) => AppNotification.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  // Save notifications to local storage
  void _saveNotifications() {
    try {
      final jsonList = _notifications.map((n) => n.toJson()).toList();
      write(_storageKey, jsonList);
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  // Add new notification
  void addNotification({
    required String title,
    required String body,
    String? type,
    Map<String, dynamic>? data,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
      data: data,
    );

    _notifications.insert(0, notification); // Add to beginning
    _saveNotifications();
    update();
  }

  // Add notification from FCM payload
  void addNotificationFromFCM(Map<String, dynamic> payload) {
    final notification = AppNotification(
      id: payload['messageId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: payload['notification']?['title'] ?? 'New Notification',
      body: payload['notification']?['body'] ?? '',
      type: payload['data']?['type'],
      timestamp: DateTime.now(),
      data: payload['data'],
    );

    _notifications.insert(0, notification);
    _saveNotifications();
    update();
  }

  // Add notice as notification
  void addNoticeNotification({
    required String title,
    required String content,
    required String noticeId,
  }) {
    addNotification(
      title: 'New Notice: $title',
      body: content.length > 100 ? '${content.substring(0, 100)}...' : content,
      type: 'announcement',
      data: {
        'notice_id': noticeId,
        'action': 'view_notice',
      },
    );
  }

  // Mark as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _saveNotifications();
      update();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _saveNotifications();
    update();
  }

  // Delete notification
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    _saveNotifications();
    update();
  }

  // Clear all notifications
  void clearAll() {
    _notifications.clear();
    _saveNotifications();
    update();
  }

  // Get notifications by type
  List<AppNotification> getNotificationsByType(String type) {
    return _notifications.where((n) => n.type == type).toList();
  }
}