class PunchResponseModel {

  final bool status;
  final String message;
  final String? type;
  final int? time;

  PunchResponseModel({
    required this.status,
    required this.message,
    this.type,
    this.time,
  });

  factory PunchResponseModel.fromJson(
      Map<String, dynamic> json) {

    return PunchResponseModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      type: json["type"],
      time: json["time"],
    );
  }
}