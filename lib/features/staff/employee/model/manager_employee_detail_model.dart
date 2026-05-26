class ManagerEmployeeDetailModel {
  bool? status;
  int? uid;
  Assignment? assignment;
  AttendanceSummary? attendanceSummary;

  ManagerEmployeeDetailModel({
    this.status,
    this.uid,
    this.assignment,
    this.attendanceSummary,
  });

  factory ManagerEmployeeDetailModel.fromJson(Map<String, dynamic> json) {
    return ManagerEmployeeDetailModel(
      status: json['status'],
      uid: json['uid'],
      assignment: json['assignment'] != null
          ? Assignment.fromJson(
              json['assignment'],
            )
          : null,
      attendanceSummary: json['attendance_summary'] != null
          ? AttendanceSummary.fromJson(
              json['attendance_summary'],
            )
          : null,
    );
  }
}

class Assignment {
  Shift? shift;

  Assignment({
    this.shift,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      shift: json['shift'] != null
          ? Shift.fromJson(
              json['shift'],
            )
          : null,
    );
  }
}

class Shift {
  String? name;
  String? startTime;
  String? endTime;

  Shift({
    this.name,
    this.startTime,
    this.endTime,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      name: json['name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}

class AttendanceSummary {
  String? status;

  AttendanceSummary({
    this.status,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      status: json['status'],
    );
  }
}
