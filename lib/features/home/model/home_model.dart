import 'package:flutter/material.dart';

class AppColors2 {
  static const primary = Color(0xff4B3DFE);
  static const bgColor = Color(0xffF5F5F5);

  static const green = Color(0xff22C55E);
  static const orange = Color(0xffF59E0B);
  static const red = Color(0xffEF4444);
  static const purple = Color(0xffA855F7);
  static const blue = Color(0xff3B82F6);

  static const textDark = Color(0xff1E293B);
  static const textGrey = Color(0xff64748B);

  static const white = Colors.white;
}


class StudentModel {
  final String name;
  final String id;
  final String course;
  final String campus;
  final String session;
  final String image;

  StudentModel({
    required this.name,
    required this.id,
    required this.course,
    required this.campus,
    required this.session,
    required this.image,
  });
}



class AttendanceCardModel {
  final String title;
  final String value;
  final String subtitle;
  final String bottomText;
  final Color color;
  final IconData icon;
  final double? progressValue;

  AttendanceCardModel({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.bottomText,
    required this.color,
    required this.icon,
    this.progressValue
  });
}



class QuickActionModel {
  final String title;
  final String value;
  final String status;
  final IconData icon;
  final Color color;

  QuickActionModel({
    required this.title,
    required this.value,
    required this.status,
    required this.icon,
    required this.color,
  });
}