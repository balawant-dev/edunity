import 'package:flutter/material.dart';

import '../model/home_model.dart';

class HomeProvider extends ChangeNotifier {
  StudentModel student = StudentModel(
    name: "Ramesh Kumar Singh",
    id: "ID: BED-2024-0892",
    course: "B.Ed 2 Year Programme",
    campus: "College Campus",
    session: "2024-25",
    image: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
  );

  List<AttendanceCardModel> attendanceCards = [
    AttendanceCardModel(
      title: "Status",
      value: "Present",
      subtitle: "82% Overall",
      bottomText: "Sch: 08:50 AM",
      color: AppColors2.green,
      icon: Icons.check_circle,
    ),
    AttendanceCardModel(
      title: "Punch In",
      value: "09:05 AM",
      subtitle: "15 min late",
      bottomText: "Sch: 08:50 AM",
      color: AppColors2.textDark,
      icon: Icons.calendar_today_outlined,
    ),
    AttendanceCardModel(
      title: "Punch Out",
      value: "09:05 AM",
      subtitle: "15 min late",
      bottomText: "Sch: 08:50 AM",
      color: AppColors2.textDark,
      icon: Icons.calendar_today_outlined,
    ),
    AttendanceCardModel(
      title: "Gate Pass",
      value: "Approved",
      subtitle: "GP-2024-0542",
      bottomText: "Exit: 02:30 PM",
      color: AppColors2.green,
      icon: Icons.badge,
    ),
  ];

  List<QuickActionModel> quickActions = [
    QuickActionModel(
      title: "Attendance",
      value: "82%",
      status: "Good",
      icon: Icons.calendar_month,
      color: AppColors2.blue,
    ),
    QuickActionModel(
      title: "Internship",
      value: "Active",
      status: "Ongoing",
      icon: Icons.work_outline,
      color: AppColors2.green,
    ),
    QuickActionModel(
      title: "Gate Pass",
      value: "02",
      status: "Pending",
      icon: Icons.assignment_outlined,
      color: AppColors2.blue,
    ),
    QuickActionModel(
      title: "Profile",
      value: "View",
      status: "View Profile",
      icon: Icons.person_outline,
      color: AppColors2.purple,
    ),
  ];
}
