import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class AppTextStyles {

  /*
  ========================================
  BOLD
  ========================================
  */

  static TextStyle bold({
    double size = 18,
    Color color = AppColors.black,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w700,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  SEMIBOLD
  ========================================
  */

  static TextStyle semiBold({
    double size = 16,
    Color color = AppColors.black,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w600,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  MEDIUM
  ========================================
  */

  static TextStyle medium({
    double size = 14,
    Color color = AppColors.black,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w500,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  REGULAR
  ========================================
  */

  static TextStyle regular({
    double size = 14,
    Color color = AppColors.black,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w400,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  LIGHT
  ========================================
  */

  static TextStyle light({
    double size = 12,
    Color color = AppColors.black,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w300,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  EXTRA BOLD
  ========================================
  */

  static TextStyle extraBold({
    double size = 20,
    Color color = AppColors.black,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w800,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  THIN
  ========================================
  */

  static TextStyle thin({
    double size = 12,
    Color color = AppColors.grey,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: FontWeight.w100,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  WHITE TEXT
  ========================================
  */

  static TextStyle white({
    double size = 14,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: fontWeight,
      color: AppColors.white,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  PRIMARY COLOR TEXT
  ========================================
  */

  static TextStyle primary({
    double size = 16,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: fontWeight,
      color: AppColors.primary,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  ERROR TEXT
  ========================================
  */

  static TextStyle error({
    double size = 13,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: fontWeight,
      color: AppColors.red,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  SUCCESS TEXT
  ========================================
  */

  static TextStyle success({
    double size = 13,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: fontWeight,
      color: AppColors.green,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /*
  ========================================
  UNDERLINE TEXT
  ========================================
  */

  static TextStyle underline({
    double size = 14,
    Color color = AppColors.primary,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: fontWeight,
      color: color,
      decoration: TextDecoration.underline,
      height: height,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }
}