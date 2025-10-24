import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CustomDatepicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<String>? onChanged;

  CustomDatepicker({
    super.key,
    required this.controller,
    required this.labelText,
    DateTime? firstDate,
    DateTime? lastDate,
    this.onChanged,
  })  : firstDate = firstDate ?? DateTime(1900),
        lastDate = lastDate ?? DateTime(2100);

  @override
  State<CustomDatepicker> createState() => _CustomDatepickerState();
}

class _CustomDatepickerState extends State<CustomDatepicker> {
  Future<void> _pickDate() async {
    DateTime now = DateTime.now();

    // Ensure initialDate is within range
    DateTime initialDate = now;
    if (initialDate.isBefore(widget.firstDate)) {
      initialDate = widget.firstDate;
    } else if (initialDate.isAfter(widget.lastDate)) {
      initialDate = widget.lastDate;
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = DateFormat("yyyy-MM-dd").format(picked);
        if (widget.onChanged != null) {
          widget.onChanged!(widget.controller.text);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            child: Text(widget.labelText,
                style: TextStyle(fontSize: 15.sp, color: Colors.white))),
        SizedBox(
          height: 3.0.h,
        ),
        TextFormField(
          controller: widget.controller,
          readOnly: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.white,),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0.r),
              borderSide:
                  BorderSide(color: Colors.white, width: 1.sp),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0.r),
              borderSide:
                  BorderSide(color: Colors.white, width: 1.sp),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0.r),
              borderSide:
                  BorderSide(color: Colors.white, width: 1.sp),
            ),
            fillColor: Colors.transparent,
            filled: true,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0.r),
              borderSide: BorderSide(color: Colors.red, width: 1.sp),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0.r),
              borderSide: BorderSide(color: Colors.red, width: 1.sp),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.0.sp),
            errorStyle: TextStyle(fontSize: 11.5.sp, color: Colors.red),
          ),
          onTap: _pickDate,
          // Remove onChanged since it won't work with readOnly
        ),
      ],
    );
  }
}