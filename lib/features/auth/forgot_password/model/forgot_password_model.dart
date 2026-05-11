

class ForgotPasswordModel {

  final bool status;

  final String message;

  final String userId;

  ForgotPasswordModel({

    required this.status,

    required this.message,

    required this.userId,
  });

  factory ForgotPasswordModel.fromJson(
      Map<String, dynamic> json){

    return ForgotPasswordModel(

      status: json["status"] ?? false,

      message: json["message"] ?? "",

      userId: json["user_id"] ?? "",
    );
  }
}