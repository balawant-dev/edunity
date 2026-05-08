import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class AppTextStyles {

  static const TextStyle bold = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const TextStyle medium = TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle regular = TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static TextStyle bold1({
    double size = 18,
    Color color = AppColors.black,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle semiBold({
    double size = 16,
    Color color = AppColors.black,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle medium1({
    double size = 14,
    Color color = AppColors.grey,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}