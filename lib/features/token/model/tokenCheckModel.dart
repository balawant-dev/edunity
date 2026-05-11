class TokenCheckModel {

  final bool status;

  final TokenData? data;

  final String message;

  final String action;

  TokenCheckModel({

    required this.status,

    this.data,

    required this.message,

    required this.action,
  });

  factory TokenCheckModel.fromJson(
      Map<String, dynamic> json){

    return TokenCheckModel(

      status:
      json["status"] ?? false,

      data: json["data"] != null

          ? TokenData.fromJson(
        json["data"],
      )

          : null,

      message:
      json["message"] ?? "",

      action:
      json["action"] ?? "",
    );
  }
}

class TokenData {

  final String uid;

  final String gid;

  final String type;

  final String collegeId;

  TokenData({

    required this.uid,

    required this.gid,

    required this.type,

    required this.collegeId,
  });

  factory TokenData.fromJson(
      Map<String, dynamic> json){

    return TokenData(

      uid:
      json["uid"].toString(),

      gid:
      json["gid"].toString(),

      type:
      json["type"] ?? "",

      collegeId:
      json["college_id"] ?? "",
    );
  }
}