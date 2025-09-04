import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onTap;
  const CustomAlert(
      {super.key,
      required this.title,
      required this.content,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(color: Colors.red, fontSize: 25.h),
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onTap,
          child: Text(
            'Yes',
            style: TextStyle(color: Colors.red, fontSize: 15.h),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Just close dialog
          },
          child: Text('No', style: TextStyle(fontSize: 15.h)),
        ),
      ],
    );
  }
}
