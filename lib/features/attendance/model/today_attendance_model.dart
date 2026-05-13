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

  factory TodayAttendanceModel.fromJson(
      Map<String, dynamic> json) {

    return TodayAttendanceModel(
      status: json["status"] ?? false,
      userType: json["user_type"],
      collegeId: json["college_id"]?.toString(),
      message: json["message"],
      assignment: json["assignment"] != null
          ? Assignment.fromJson(json["assignment"])
          : null,
      attendanceSummary:
      json["attendance_summary"] != null
          ? AttendanceSummary.fromJson(
          json["attendance_summary"])
          : null,
    );
  }
}

class Assignment {

  final List<LocationModel> locations;

  Assignment({
    required this.locations,
  });

  factory Assignment.fromJson(
      Map<String, dynamic> json) {

    return Assignment(
      locations:
      (json["locations"] as List? ?? [])
          .map((e) =>
          LocationModel.fromJson(e))
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

  factory LocationModel.fromJson(
      Map<String, dynamic> json) {

    return LocationModel(
      locationId:
      json["location_id"] ?? "",
      name: json["name"] ?? "",
      lat: json["lat"].toString(),
      lng: json["lng"].toString(),
      radiusInMeter:
      json["radius_in_meter"] ?? 0,
    );
  }
}

class AttendanceSummary {

  final String status;
  final int totalPunches;

  AttendanceSummary({
    required this.status,
    required this.totalPunches,
  });

  factory AttendanceSummary.fromJson(
      Map<String, dynamic> json) {

    return AttendanceSummary(
      status: json["status"] ?? "",
      totalPunches:
      json["total_punches"] ?? 0,
    );
  }
}