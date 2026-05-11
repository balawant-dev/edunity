class ProfileModel {

  final bool status;

  final ProfileData data;

  ProfileModel({

    required this.status,

    required this.data,
  });

  factory ProfileModel.fromJson(
      Map<String, dynamic> json){

    return ProfileModel(

      status: json["status"] ?? false,

      data: ProfileData.fromJson(
        json["data"] ?? {},
      ),
    );
  }
}

class ProfileData {

  final String uid;

  final String userId;

  final String email;

  final String fieldName;

  final String fieldMobile;

  final List<String> roles;

  final String type;

  final String dob;

  final String fatherName;

  final String aadhar;

  final String course;

  final String session;

  final String photo;

  final String address;

  ProfileData({

    required this.uid,

    required this.userId,

    required this.email,

    required this.fieldName,

    required this.fieldMobile,

    required this.roles,

    required this.type,

    required this.dob,

    required this.fatherName,

    required this.aadhar,

    required this.course,

    required this.session,

    required this.photo,

    required this.address,
  });

  factory ProfileData.fromJson(
      Map<String, dynamic> json){

    return ProfileData(

      uid: json["uid"] ?? "",

      userId: json["user_id"] ?? "",

      email: json["email"] ?? "",

      fieldName: json["field_name"] ?? "",

      fieldMobile: json["field_mobile"] ?? "",

      roles: List<String>.from(
        json["roles"] ?? [],
      ),

      type: json["type"] ?? "",

      dob: json["dob"] ?? "",

      fatherName: json["father_name"] ?? "",

      aadhar: json["aadhar"] ?? "",

      course: json["course"] ?? "",

      session: json["session"] ?? "",

      photo: json["photo"] ?? "",

      address: json["address"] ?? "",
    );
  }
}