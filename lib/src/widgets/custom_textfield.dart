import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final String headingText;
  final TextStyle? headingTextStyle;
  final String? infoText;
  final String? impText;
  final String? initialValue;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? isRequired;
  final bool? isOptional;
  final bool? isDropdown;
  final bool? isSuffixLoading;
  final bool readOnly;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final Color? cursorColor;
  final Color? filledColor;
  final bool? filled;
  final int? maxLines;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final AutovalidateMode? autoValidateMode;
  final bool? isDisabled;
  final FocusNode? focusNode;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? infoTextStyle;
  final int? maxLength;
  final String? reqText;

  const CustomTextFormField(
      {super.key,
      this.initialValue,
      this.controller,
      this.labelText,
      this.hintText,
      this.labelStyle,
      this.hintStyle,
      this.textStyle,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText = false,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onChanged,
      this.border,
      this.enabledBorder,
      this.focusedBorder,
      this.errorBorder,
      this.disabledBorder,
      this.cursorColor,
      this.maxLines,
      this.width,
      this.height,
      this.filledColor,
      this.filled,
      this.autofocus = false,
      this.readOnly = false,
      this.onTap,
      this.autoValidateMode,
      this.isDisabled,
      this.inputFormatters,
      this.onFieldSubmitted,
      this.focusNode,
      required this.headingText,
      this.isRequired,
      this.isDropdown,
      this.isOptional,
      this.infoText,
      this.infoTextStyle,
      this.maxLength,
      this.isSuffixLoading,
      this.reqText,
      this.impText,
      this.headingTextStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading Text and Required
        SizedBox(
            // width: width != null ? width!/2 : null,
            child: Text(headingText,
                style: headingTextStyle ??
                    TextStyle(fontSize: 12.sp, color: Colors.white))),
        SizedBox(
          height: 3.0.h,
        ),
        // TextField
        SizedBox(
          width: width,
          height: height,
          child: TextFormField(
            style: textStyle ?? TextStyle(fontSize: 16.sp, color: Colors.white),
            focusNode: focusNode,
            inputFormatters: inputFormatters ?? [],
            onTap: isSuffixLoading == true ? () {} : onTap,
            autofocus: autofocus!,
            autovalidateMode:
                autoValidateMode ?? AutovalidateMode.onUserInteraction,
            initialValue: initialValue,
            controller: controller,
            obscureText: obscureText,
            readOnly: isDropdown == true ? true : readOnly,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            cursorColor: cursorColor ?? Colors.white,
            maxLines: maxLines ?? 1,
            maxLength: maxLength,
            decoration: InputDecoration(
              errorMaxLines: 3,
              labelText: labelText,
              hintText: hintText,
              labelStyle: labelStyle,
              hintStyle:
                  hintStyle ?? TextStyle(fontSize: 16.sp, color: Colors.white),
              prefixIcon: prefixIcon,
              suffixIcon: isSuffixLoading == true
                  ? Container(
                      height: 48.h,
                      width: 48.h,
                      padding: EdgeInsets.all(14.sp),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.8.sp,
                        ),
                      ),
                    )
                  : isDropdown == true
                      ? const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xff575757),
                        )
                      : suffixIcon,
              border: border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0.r),
                    borderSide: BorderSide(color: Colors.white, width: 1.sp),
                  ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0.r),
                borderSide:
                    BorderSide(color: const Color(0xff575757), width: 1.sp),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0.r),
                borderSide: BorderSide(color: Colors.white, width: 1.sp),
              ),
              fillColor: filledColor ?? Colors.transparent,
              filled: true,
              errorBorder: errorBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0.r),
                    borderSide: BorderSide(color: Colors.red, width: 1.sp),
                  ),
              focusedErrorBorder: errorBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0.r),
                    borderSide: BorderSide(color: Colors.red, width: 1.sp),
                  ),
              disabledBorder: disabledBorder,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.0.sp),
              errorStyle: TextStyle(fontSize: 11.5.sp, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
