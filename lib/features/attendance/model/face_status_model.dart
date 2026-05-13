class FaceStatusModel {

  final bool status;
  final String registrationStatus;
  final String? profileId;
  final int? imageCount;
  final int? primaryImageCount;
  final String? submittedAt;
  final String? approvedAt;
  final String? approvedBy;
  final String? remark;
  final int? submissionCount;
  final bool canResubmit;

  FaceStatusModel({


    required this.status,
    required this.registrationStatus,
    this.profileId,
    this.imageCount,
    this.primaryImageCount,
    this.submittedAt,
    this.approvedAt,
    this.approvedBy,
    this.remark,
    this.submissionCount,
    required this.canResubmit,
  });

  factory FaceStatusModel.fromJson(
      Map<String, dynamic> json) {

    return FaceStatusModel(
      status: json["status"] ?? false,
      registrationStatus:
      json["registration_status"] ?? "",
      profileId: json["profile_id"]?.toString(),
      imageCount: json["image_count"],
      primaryImageCount:
      json["primary_image_count"],
      submittedAt: json["submitted_at"],
      approvedAt: json["approved_at"],
      approvedBy: json["approved_by"],
      remark: json["remark"],
      submissionCount:
      json["submission_count"],
      canResubmit:
      json["can_resubmit"] ?? false,
    );
  }
}