import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:campus_connect/src/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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
        final isOnline = snapshot.data ?? true;

        return Material(
          child: Stack(
            children: [
              widget.child,
              if (!isOnline)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 40,
                      sigmaY: 40,
                    ),
                    child: Container(
                      color: Colors.black.withAlpha(51),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.wifi_off,
                                  color: Colors.white,
                                  size: 80,
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 35.0,
                                        color: Colors.blueGrey),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No Internet Connection',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(2.0, 2.0),
                                          blurRadius: 35.0,
                                          color: Colors.blueGrey),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
