

class OtpModel {

  final bool status;

  final String message;

  OtpModel({

    required this.status,

    required this.message,
  });

  factory OtpModel.fromJson(
      Map<String, dynamic> json){

    return OtpModel(

      status: json["status"] ?? false,

      message: json["message"] ?? "",
    );
  }
}