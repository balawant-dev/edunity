import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/attendance_report_model.dart';
import '../repo/attendance_report_repository.dart';

class PunchSummaryProvider extends ChangeNotifier {
  final repository = AttendanceReportRepository();

  bool isLoading = false;

  DateTime selectedDate = DateTime.now();

  AttendanceReportModel? reportModel;

  Future<void> getPunchReport() async {
    try {
      isLoading = true;
      notifyListeners();

      final date = DateFormat(
        "yyyy-MM-dd",
      ).format(
        selectedDate,
      );

      reportModel = await repository.getAttendanceReport(
        fromDate: date,
        toDate: date,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void nextDate() {
    selectedDate = selectedDate.add(
      const Duration(
        days: 1,
      ),
    );

    getPunchReport();
  }

  void previousDate() {
    selectedDate = selectedDate.subtract(
      const Duration(
        days: 1,
      ),
    );

    getPunchReport();
  }

  Future<void> pickDate(
    BuildContext context,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      selectedDate = picked;

      getPunchReport();
    }
  }

  String get formattedDate => DateFormat(
        "dd MMM yyyy",
      ).format(
        selectedDate,
      );

  String get dayName => DateFormat(
        "EEEE",
      ).format(
        selectedDate,
      );
}
