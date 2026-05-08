import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final String? label;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.label,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        if(label != null)...[
          Text(
            label!,
            style: AppTextStyles.semiBold(
              size: 13,
              color: const Color(0xFF75758A),
            ),
          ),

          SizedBox(height: 10.h),
        ],

        TextField(

          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,

          decoration: InputDecoration(

            hintText: hintText,

            hintStyle:  TextStyle(
    color: const Color(0x995E5E5E),
    fontSize: 14.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    ),

            filled: true,

            fillColor: AppColors.textField,

            suffixIcon: suffixIcon,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 18.w,
              vertical: 14.h,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.2.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}