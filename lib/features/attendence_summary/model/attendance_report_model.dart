class AttendanceReportModel {
  bool? status;
  String? userType;
  Summary? summary;
  List<AttendanceLog>? logs;

  AttendanceReportModel({
    this.status,
    this.userType,
    this.summary,
    this.logs,
  });

  AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userType = json['user_type'];

    summary = json['summary'] != null
        ? Summary.fromJson(
            json['summary'],
          )
        : null;

    if (json['logs'] != null) {
      logs = [];
      json['logs'].forEach((v) {
        logs!.add(
          AttendanceLog.fromJson(v),
        );
      });
    }
  }
}

class Summary {
  int? totalDays;
  int? presentDays;
  int? absentDays;
  int? lateDays;
  int? holidayDays;
  int? weeklyOffDays;

  Summary.fromJson(Map<String, dynamic> json) {
    totalDays = json['total_days'];
    presentDays = json['present_days'];
    absentDays = json['absent_days'];
    lateDays = json['late_days'];
    holidayDays = json['holiday_days'];
    weeklyOffDays = json['weekly_off_days'];
  }
}

class AttendanceLog {
  String? attendanceDate;
  String? dayName;
  String? status;
  int? punchesCount;
  List<Timeline>? timeline;

  AttendanceLog.fromJson(Map<String, dynamic> json) {
    attendanceDate = json['attendance_date'];
    dayName = json['day_name'];
    status = json['status'];
    punchesCount = json['punches_count'];

    if (json['timeline'] != null) {
      timeline = [];
      json['timeline'].forEach((v) {
        timeline!.add(
          Timeline.fromJson(v),
        );
      });
    }
  }
}

class Timeline {
  String? type;
  int? punchTime;
  String? location;
  String? note;

  Timeline.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    punchTime = json['punch_time'];
    location = json['location'];
    note = json['note'];
  }
}
