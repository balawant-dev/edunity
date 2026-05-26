class ProfileModel {
  final bool status;
  final ProfileData data;

  ProfileModel({required this.status, required this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      status: json["status"] ?? false,
      data: ProfileData.fromJson(json["data"] ?? {}),
    );
  }
}

class ProfileData {
  final String uid;
  final String userId;
  final String email;
  final String fieldName;
  final String course;
  final String fieldMobile;
  final List<String> roles;
  final String type;
  final String dob;
  final String fatherName;
  final String aadhar;
  final String department;
  final String designation;
  final String bloodGroup;
  final String photo;
  final String address;
  final EmergencyContact? emergencyContact;
  final CollegeDetails? collegeDetails;
  final bool isAttendanceManager;
  final bool isFaceCaptureManager;

  ProfileData({
    required this.uid,
    required this.userId,
    required this.email,
    required this.fieldName,
    required this.course,
    required this.fieldMobile,
    required this.roles,
    required this.type,
    required this.dob,
    required this.fatherName,
    required this.aadhar,
    required this.department,
    required this.designation,
    required this.bloodGroup,
    required this.photo,
    required this.address,
    this.emergencyContact,
    this.collegeDetails,
    required this.isAttendanceManager,
    required this.isFaceCaptureManager,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      uid: json["uid"]?.toString() ?? "",
      userId: json["user_id"] ?? "",
      email: json["email"] ?? "",
      fieldName: json["field_name"] ?? "",
      course: json["course"] ?? "",
      fieldMobile: json["field_mobile"] ?? "",
      roles: List<String>.from(json["roles"] ?? []),
      type: json["type"] ?? "",
      dob: json["dob"] ?? "",
      fatherName: json["father_name"] ?? "",
      aadhar: json["aadhar"] ?? "",
      department: json["department"] ?? "",
      designation: json["designation"] ?? "",
      bloodGroup: json["blood_group"] ?? "",
      photo: json["photo"] ?? "",
      address: json["address"] ?? "",
      emergencyContact: json["emergency_contact"] != null
          ? EmergencyContact.fromJson(json["emergency_contact"])
          : null,
      collegeDetails: json["college_details"] != null
          ? CollegeDetails.fromJson(json["college_details"])
          : null,
      isAttendanceManager: json["is_attendance_manager"] ?? false,
      isFaceCaptureManager: json["is_face_capture_manager"] ?? false,
    );
  }
}

class EmergencyContact {
  final String name;
  final String relation;
  final String contact;

  EmergencyContact(
      {required this.name, required this.relation, required this.contact});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json["name"] ?? "",
      relation: json["relation"] ?? "",
      contact: json["contact"] ?? "",
    );
  }
}

class CollegeDetails {
  final String college;
  final String address;
  final String website;
  final String contactNo;

  CollegeDetails(
      {required this.college,
      required this.address,
      required this.website,
      required this.contactNo});

  factory CollegeDetails.fromJson(Map<String, dynamic> json) {
    return CollegeDetails(
      college: json["college"] ?? "",
      address: json["address"] ?? "",
      website: json["website"] ?? "",
      contactNo: json["contact_no"] ?? "",
    );
  }
}
