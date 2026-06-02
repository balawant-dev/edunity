// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class PunchData {
//   final String type;
//   final String time;
//   final String location;
//   final String note;
//   final Color color;
//   final bool isOnTime;
//
//   PunchData({
//     required this.type,
//     required this.time,
//     required this.location,
//     required this.note,
//     required this.color,
//     this.isOnTime = false,
//   });
// }
//
// class PunchSummaryProvider with ChangeNotifier {
//   final List<PunchData> punches = [
//     PunchData(
//       type: "Punched In",
//       time: "08:50 AM",
//       location: "College Campus",
//       note: "-",
//       color: Colors.green,
//       isOnTime: true,
//     ),
//     PunchData(
//       type: "Punched Out",
//       time: "01:15 PM",
//       location: "College Campus",
//       note: "Lunch Break",
//       color: Colors.red,
//     ),
//     PunchData(
//       type: "Punched In",
//       time: "02:00 PM",
//       location: "College Campus",
//       note: "Back from Break",
//       color: Colors.blue,
//     ),
//   ];
//
//   String get totalWorkingHours => "07h 45m";
//   int get totalPunches => punches.length;
//   String get firstPunchIn => "08:50 AM";
//   String get lastPunchOut => "01:15 PM";
//
//
//
//   DateTime selectedDate = DateTime.now();
//
//   /// DATE FORMAT
//   String get formattedDate {
//     return DateFormat('dd MMM yyyy').format(selectedDate);
//   }
//
//   /// DAY FORMAT
//   String get dayName {
//     return DateFormat('EEEE').format(selectedDate);
//   }
//
//   /// DATE PICKER
//   Future<void> pickDate(BuildContext context) async {
//
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate != null) {
//       selectedDate = pickedDate;
//       notifyListeners();
//     }
//   }
//
//
//   void previousDate() {
//     selectedDate = selectedDate.subtract(
//       const Duration(days: 1),
//     );
//
//     notifyListeners();
//   }
//
//   /// NEXT DATE
//   void nextDate() {
//     selectedDate = selectedDate.add(
//       const Duration(days: 1),
//     );
//
//     notifyListeners();
//   }
// }
