import 'package:flutter/material.dart';

import '../model/attendance_report_model.dart';
import '../repo/attendance_report_repository.dart';

class AttendanceReportProvider extends ChangeNotifier {
  final repository = AttendanceReportRepository();

  bool isLoading = false;

  AttendanceReportModel? reportModel;

  DateTime selectedMonth = DateTime.now();

  Future<void> getAttendanceReport() async {
    try {
      isLoading = true;
      notifyListeners();

      final firstDay = DateTime(
        selectedMonth.year,
        selectedMonth.month,
        1,
      );

      final lastDay = DateTime(
        selectedMonth.year,
        selectedMonth.month + 1,
        0,
      );

      reportModel = await repository.getAttendanceReport(
        fromDate: firstDay
            .toIso8601String()
            .split(
              "T",
            )
            .first,
        toDate: lastDay
            .toIso8601String()
            .split(
              "T",
            )
            .first,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
