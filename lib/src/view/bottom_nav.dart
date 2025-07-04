import 'package:campus_connect/src/view/home_page.dart';
import 'package:campus_connect/src/view/notice_page.dart';
import 'package:campus_connect/src/view/routine_page.dart';
import 'package:campus_connect/src/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavPage extends StatefulWidget {
  final int initialIndex;

  const BottomNavPage({super.key, required this.initialIndex});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  late int index;

  final List<Widget> pages = [
    HomePage(),
    NoticePage(),
    RoutinePage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();

    index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        debugPrint(result.toString());
      },
      child: Scaffold(
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff131631),
          selectedFontSize: 0,
          unselectedFontSize: 0,
          currentIndex: index,
          onTap: (int newIndex) {
            setState(() {
              index = newIndex;
            });
          },
          selectedItemColor: Color(0xffD73800),
          unselectedItemColor: Color(0xffFFFFFF),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/home.svg',
                  colorFilter: ColorFilter.mode(
                      index == 0 ? Color(0xffD73800) : Color(0xffFFFFFF),
                      BlendMode.srcIn)),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/notices.svg',
                colorFilter: ColorFilter.mode(
                    index == 1 ? Color(0xffD73800) : Color(0xffFFFFFF),
                    BlendMode.srcIn),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/routines.svg',
                colorFilter: ColorFilter.mode(
                    index == 2 ? Color(0xffD73800) : Color(0xffFFFFFF),
                    BlendMode.srcIn),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/settings.svg',
                colorFilter: ColorFilter.mode(
                    index == 3 ? Color(0xffD73800) : Color(0xffFFFFFF),
                    BlendMode.srcIn),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
