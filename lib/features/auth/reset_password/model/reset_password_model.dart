

class ResetPasswordModel {

  final bool status;

  final String message;

  ResetPasswordModel({

    required this.status,

    required this.message,
  });

  factory ResetPasswordModel.fromJson(
      Map<String, dynamic> json){

    return ResetPasswordModel(

      status: json["status"] ?? false,

      message: json["message"] ?? "",
    );
  }
}