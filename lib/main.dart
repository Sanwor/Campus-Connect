import 'dart:developer';

import 'package:campus_connect/src/app_config/constant.dart';
import 'package:campus_connect/src/app_config/dio_interceptor.dart';
import 'package:campus_connect/src/controller/auth_controller.dart';
import 'package:campus_connect/src/controller/profile_controller.dart';
import 'package:campus_connect/src/services/auth_service.dart';
import 'package:campus_connect/src/services/notice_service.dart';
import 'package:campus_connect/src/services/notification_services.dart';
import 'package:campus_connect/src/services/profile_services.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:campus_connect/src/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> backgroundHandler(RemoteMessage message) async{
  debugPrint(message.data.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await NotificationService.initNotification();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  // Initialize Dio (add this before runApp)
  // Update your Dio initialization in main.dart
final dio = Dio(
  BaseOptions(
    baseUrl: getBaseUrl(),
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ),
)
  ..interceptors.add(DioInterceptor())
  ..interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
    logPrint: (object) => log(object.toString()),
  ));

  // Register instances
  Get.put<Dio>(dio);
  Get.put<AuthService>(AuthService(dio));
  Get.put<NoticeService>(NoticeService(dio));
  Get.put<AuthController>(AuthController());
  Get.put<ProfileService>(ProfileService(dio));
  Get.put<ProfileController>(ProfileController());
  
  runApp(const MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    //Detect Push Notiication acc to app lifecycle
    NotificationService.getPushedNotification(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(410, 830),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
            title: 'CampusConnect',
            home: SplashScreen(),
            theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return GlobalConnectivityWrapper(
                child: child!,
              );
            });
      },
    );
  }
}

//for internet connection check
class GlobalConnectivityWrapper extends StatefulWidget {
  final Widget child;
  const GlobalConnectivityWrapper({super.key, required this.child});

  @override
  State<GlobalConnectivityWrapper> createState() =>
      _GlobalConnectivityWrapperState();
}

class _GlobalConnectivityWrapperState extends State<GlobalConnectivityWrapper> {
  late Stream<bool> connectivityStream;

  @override
  void initState() {
    super.initState();
    connectivityStream = _createConnectivityStream();
  }

  Stream<bool> _createConnectivityStream() async* {
    final Connectivity connectivity = Connectivity();
    var initial = await connectivity.checkConnectivity();
    yield await _hasInternet(initial[0]);

    await for (final result in connectivity.onConnectivityChanged) {
      yield await _hasInternet(result[0]);
    }
  }

  Future<bool> _hasInternet(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      try {
        final response = await http
            .get(Uri.parse("http://clients3.google.com/generate_204"))
            .timeout(const Duration(seconds: 3));
        return response.statusCode == 204;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: connectivityStream,
      initialData: true,
      builder: (context, snapshot) {
        RxBool isOnline = true.obs;

        return Obx(
          () {
            final online = snapshot.data;
            isOnline.value = online ?? true;
            return Stack(
              children: [
                widget.child,

                // floating banner only when offline
                if (!isOnline.value)
                  Positioned(
                    child: SafeArea(
                      child: Material(
                        elevation: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off, color: Colors.white),
                              SizedBox(width: 8.w),
                              Text(
                                "Offline",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
