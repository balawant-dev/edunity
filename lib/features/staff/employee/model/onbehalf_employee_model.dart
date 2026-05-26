class OnBehalfEmployeeModel {
  bool? status;
  int? total;
  List<EmployeeData>? data;

  OnBehalfEmployeeModel({
    this.status,
    this.total,
    this.data,
  });

  factory OnBehalfEmployeeModel.fromJson(Map<String, dynamic> json) {
    return OnBehalfEmployeeModel(
      status: json['status'],
      total: json['total'],
      data: (json['data'] as List?)
          ?.map(
            (e) => EmployeeData.fromJson(e),
          )
          .toList(),
    );
  }
}

class EmployeeData {
  int? uid;
  int? employeeNid;
  String? employeeId;
  String? name;
  String? fatherName;
  String? motherName;
  String? dateOfBirth;
  String? department;
  String? designation;
  String? email;
  String? mobile;
  String? college;
  String? faceRegistrationStatus;

  EmployeeData({
    this.uid,
    this.employeeNid,
    this.employeeId,
    this.name,
    this.fatherName,
    this.motherName,
    this.dateOfBirth,
    this.department,
    this.designation,
    this.email,
    this.mobile,
    this.college,
    this.faceRegistrationStatus,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      uid: json['uid'],
      employeeNid: json['employee_nid'],
      employeeId: json['employee_id'],
      name: json['name'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      dateOfBirth: json['date_of_birth'],
      department: json['department'],
      designation: json['designation'],
      email: json['email'],
      mobile: json['mobile'],
      college: json['college'],
      faceRegistrationStatus: json['face_registration_status'],
    );
  }
}
