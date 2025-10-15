import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

enum NotificationState {
  foreground,
  background,
  terminated
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  static final messaging = FirebaseMessaging.instance;
  
  checkNotificationStatus() async {
    final status = await messaging.getNotificationSettings();
    // bool authorized = status.authorizationStatus == AuthorizationStatus.authorized;
    return status.authorizationStatus;
  }

  static initNotification() async {
    // // Notificiaton Permission
    var isSuccess = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // //Get the fcm Token
    // // getFcmToken();
    // //Request Notification permission
    // requestNotificationPermission();
    //Initialize notification settings
    if(isSuccess.authorizationStatus == AuthorizationStatus.authorized){
      initializeNotification();
    }
    
  }

  //Initialize Local Notification
  static initializeNotification() async{
    //For Android Settings
    var initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher');

    //For Ios Settings
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveBackgroundNotificationResponse: (NotificationResponse notificationResponse) async {
      //   if (notificationResponse.payload != null) {
      //     showNotification(message: notificationResponse.payload!);
      //   }
      // },
    );


    //Initialize Notification settings
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: (notificationResponse) {
          onForgroundNotificaiton(respnse: notificationResponse);
        },
        onDidReceiveNotificationResponse:(notificationResponse) async {
          onForgroundNotificaiton(respnse: notificationResponse);
        }
      );
      await notificationsPlugin.initialize(initializationSettings);
  }

  // //Ask for notification permission
  // static requestNotificationPermission() async {
  //   //For Android Permission
  //   if(Platform.isAndroid){
  //     await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
  //   }

  //   // //For IOS permission
  //   if(Platform.isIOS){
  //     await notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!.requestPermissions();
  //   }
  //   // await DeviceCalendarHelper().fetchCalendars();
  // }

  //Get Fcm Token
  static getFcmToken() async{
    String? fcm = await messaging.getToken();
    debugPrint("fcm -> $fcm");
    return fcm;
  }

  //Notification Details
  static notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'Campus', //Channel Id
        'Campus', //Channel name
        importance: Importance.high,
        icon: "ic_launcher",
      ),
      iOS: DarwinNotificationDetails(
        interruptionLevel: InterruptionLevel.critical,
        presentList: true,
        presentBadge: true,
        presentAlert: true,
        presentBanner: true,
        presentSound: true,
      )
    );
  }

  //Show Notification
  static showNotification({message}) async {
    try {
      // final id = DateTime.now().millisecondsSinceEpoch ~/1000;
      await notificationsPlugin.show(
        0,
        message.notification!.title ?? "", 
        message.notification!.body ?? "", 
        notificationDetails(),
        payload: jsonEncode(message.data)
      );
      //Initialize Settings, required to detect on tap on ios
      await initializeNotification();
    } catch (e){
      debugPrint(e.toString());
    }
  }

  //Detect and Get Push Notification
  static getPushedNotification(context) async{
    
    //On App Terminated
    messaging.getInitialMessage().then((message)async{
      if(message != null ){
        //Route on App Terminated
        routeFromNotification(NotificationState.terminated, message);
      }
    });

    //On Foreground Message
    FirebaseMessaging.onMessage.listen((message) async{
      // Updated Notificaiton Count On Push Notification
      showNotification(
        message: message
      );
    });

    //On Backgorund Message
    FirebaseMessaging.onMessageOpenedApp.listen((message) async{
      routeFromNotification(NotificationState.background, message);
    });
  }

  //Shedule Notification
  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime
      }
  ) {
    tz.initializeTimeZones();
    return notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    // scheduledNotificationDateTime as tz.TZDateTime,
    tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
    notificationDetails(),
    // androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime, 
    androidScheduleMode: AndroidScheduleMode.alarmClock);
  }

  // On Tap Of Notificaiton On Forground
  static onForgroundNotificaiton({respnse}){
    if(respnse.payload !=null && respnse.payload != ""){
      routeFromNotification(NotificationState.foreground, respnse.payload);
    }
  }


  //---------------------- Route From Notification ---------------------------------
  static routeFromNotification(NotificationState type, message)async{
    dynamic messageData;
    // Sort Out Data
    if (type == NotificationState.foreground){
      messageData = jsonDecode(message);
    } else {
      messageData = message.data;
    }

    if(messageData.isNotEmpty){}
  }
}