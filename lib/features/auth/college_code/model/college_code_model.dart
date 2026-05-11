class CollegeModel {

  final bool status;

  final CollegeData data;

  CollegeModel({
    required this.status,
    required this.data,
  });

  factory CollegeModel.fromJson(
      Map<String, dynamic> json){

    return CollegeModel(

      status: json["status"],

      data: CollegeData.fromJson(
        json["data"],
      ),
    );
  }
}

class CollegeData {

  final String gid;

  final String name;

  final String instituteCode;

  final String fullName;

  final String logo;

  CollegeData({
    required this.gid,
    required this.name,
    required this.instituteCode,
    required this.fullName,
    required this.logo,
  });

  factory CollegeData.fromJson(
      Map<String, dynamic> json){

    return CollegeData(

      gid: json["gid"].toString(),

      name: json["name"] ?? "",

      instituteCode:
      json["institute_code"] ?? "",

      fullName: json["full_name"] ?? "",

      logo: json["logo"] ?? "",
    );
  }
}