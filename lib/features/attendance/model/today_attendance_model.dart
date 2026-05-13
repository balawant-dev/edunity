class TodayAttendanceModel {
  final bool status;
  final String? userType;
  final String? collegeId;
  final Assignment? assignment;
  final AttendanceSummary? attendanceSummary;
  final String? message;

  TodayAttendanceModel({
    required this.status,
    this.userType,
    this.collegeId,
    this.assignment,
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
      attendanceSummary: json["attendance_summary"] != null
          ? AttendanceSummary.fromJson(json["attendance_summary"])
          : null,
    );
  }
}

class Assignment {
  final List<LocationModel> locations;

  Assignment({required this.locations});

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      locations: (json["locations"] as List? ?? [])
          .map((e) => LocationModel.fromJson(e))
          .toList(),
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
      lat: json["lat"].toString(),
      lng: json["lng"].toString(),
      radiusInMeter: json["radius_in_meter"] ?? 0,
    );
  }
}

class AttendanceSummary {
  final String attendanceDate;
  final String dayName;
  final String status;
  final int totalPunches;
  final int punchInTime;
  final int punchOutTime;
  final List<Timeline> timeline;

  AttendanceSummary({
    required this.attendanceDate,
    required this.dayName,
    required this.status,
    required this.totalPunches,
    required this.punchInTime,
    required this.punchOutTime,
    required this.timeline,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      attendanceDate: json["attendance_date"] ?? "",
      dayName: json["day_name"] ?? "",
      status: json["status"] ?? "",
      totalPunches: json["total_punches"] ?? 0,
      punchInTime: json["punch_in_time"] ?? 0,
      punchOutTime: json["punch_out_time"] ?? 0,
      // Timeline list ko map kar rahe hain
      timeline: json["timeline"] != null
          ? List<Timeline>.from(json["timeline"].map((x) => Timeline.fromJson(x)))
          : [],
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
