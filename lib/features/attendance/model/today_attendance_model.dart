class TodayAttendanceModel {
  final bool status;
  final String? userType;
  final String? collegeId;
  final Assignment? assignment;
  final List<AttendancePolicy> policies;
  final AttendanceSummary? attendanceSummary;
  final String? message;

  TodayAttendanceModel({
    required this.status,
    this.userType,
    this.collegeId,
    this.assignment,
    this.policies = const [],
    this.attendanceSummary,
    this.message,
  });

  factory TodayAttendanceModel.fromJson(Map<String, dynamic> json) {
    return TodayAttendanceModel(
      status: json["status"] ?? false,
      userType: json["user_type"],
      collegeId: json["college_id"]?.toString(),
      message: json["message"],
      assignment: json["assignment"] != null
          ? Assignment.fromJson(json["assignment"])
          : null,
      policies: (json["policies"] as List? ?? [])
          .map((e) => AttendancePolicy.fromJson(e))
          .toList(),
      attendanceSummary: json["attendance_summary"] != null
          ? AttendanceSummary.fromJson(json["attendance_summary"])
          : null,
    );
  }
}

class Assignment {
  final Shift? shift;
  final List<LocationModel> locations;
  final List<ShiftBreak> shiftBreaks;
  final bool isFieldStaff;
  final String? validFrom;

  Assignment({
    this.shift,
    required this.locations,
    this.shiftBreaks = const [],
    required this.isFieldStaff,
    this.validFrom,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      shift: json["shift"] != null ? Shift.fromJson(json["shift"]) : null,
      locations: (json["locations"] as List? ?? [])
          .map((e) => LocationModel.fromJson(e))
          .toList(),
      shiftBreaks: (json["shift_breaks"] as List? ?? [])
          .map((e) => ShiftBreak.fromJson(e))
          .toList(),
      isFieldStaff: json["is_field_staff"] ?? false,
      validFrom: json["valid_from"],
    );
  }
}

class Shift {
  final String name;
  final String shiftId;
  final String startTime;
  final String endTime;
  final String lunchIn;
  final String lunchOut;

  Shift({
    required this.name,
    required this.shiftId,
    required this.startTime,
    required this.endTime,
    required this.lunchIn,
    required this.lunchOut,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      name: json["name"] ?? "",
      shiftId: json["shift_id"] ?? "",
      startTime: json["start_time"] ?? "",
      endTime: json["end_time"] ?? "",
      lunchIn: json["lunch_in"] ?? "",
      lunchOut: json["lunch_out"] ?? "",
    );
  }
}

class ShiftBreak {
  final int shiftBreakId;
  final String name;
  final String breakType;
  final int hour;
  final int minute;

  ShiftBreak({
    required this.shiftBreakId,
    required this.name,
    required this.breakType,
    required this.hour,
    required this.minute,
  });

  factory ShiftBreak.fromJson(Map<String, dynamic> json) {
    return ShiftBreak(
      shiftBreakId: json["shift_break_id"] ?? 0,
      name: json["name"] ?? "",
      breakType: json["break_type"] ?? "",
      hour: json["hour"] ?? 0,
      minute: json["minute"] ?? 0,
    );
  }
}

class LocationModel {
  final String locationId;
  final String name;
  final String lat;
  final String lng;
  final int radiusInMeter;

  LocationModel({
    required this.locationId,
    required this.name,
    required this.lat,
    required this.lng,
    required this.radiusInMeter,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      locationId: json["location_id"] ?? "",
      name: json["name"] ?? "",
      lat: json["lat"]?.toString() ?? "",
      lng: json["lng"]?.toString() ?? "",
      radiusInMeter: json["radius_in_meter"] ?? 0,
    );
  }
}

class AttendancePolicy {
  final String policyType;
  final int gracePeriodSeconds;
  final int maxRepeats;
  final double penaltyMultiplier;
  final bool mustProvideReason;

  AttendancePolicy({
    required this.policyType,
    required this.gracePeriodSeconds,
    required this.maxRepeats,
    required this.penaltyMultiplier,
    required this.mustProvideReason,
  });

  factory AttendancePolicy.fromJson(Map<String, dynamic> json) {
    return AttendancePolicy(
      policyType: json["policy_type"] ?? "",
      gracePeriodSeconds: json["grace_period_seconds"] ?? 0,
      maxRepeats: json["max_repeats"] ?? 0,
      penaltyMultiplier: (json["penalty_multiplier"] ?? 0).toDouble(),
      mustProvideReason: json["must_provide_reason"] ?? false,
    );
  }
}

class AttendanceSummary {
  final String attendanceDate;
  final String dayName;
  final String status;
  final int totalPunches;
  final int? punchInTime;
  final int? punchOutTime;
  final String? workingHours;
  final String? otHours;
  final String? shortHours;
  final List<Timeline> timeline;

  AttendanceSummary({
    required this.attendanceDate,
    required this.dayName,
    required this.status,
    required this.totalPunches,
    this.punchInTime,
    this.punchOutTime,
    this.workingHours,
    this.otHours,
    this.shortHours,
    required this.timeline,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      attendanceDate: json["attendance_date"] ?? "",
      dayName: json["day_name"] ?? "",
      status: json["status"] ?? "",
      totalPunches: json["total_punches"] ?? 0,
      punchInTime: json["punch_in_time"] ?? 0,
      punchOutTime: json["punch_out_time"],
      workingHours: json["working_hours"],
      otHours: json["ot_hours"],
      shortHours: json["short_hours"],
      timeline: (json["timeline"] as List? ?? [])
          .map((e) => Timeline.fromJson(e))
          .toList(),
    );
  }
}

class Timeline {
  final String type;
  final int punchTime;
  final String location;
  final String locationId;
  final String note;

  Timeline({
    required this.type,
    required this.punchTime,
    required this.location,
    required this.locationId,
    required this.note,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      type: json["type"] ?? "",
      punchTime: json["punch_time"] ?? 0,
      location: json["location"] ?? "",
      locationId: json["location_id"] ?? "",
      note: json["note"] ?? "",
    );
  }
}
