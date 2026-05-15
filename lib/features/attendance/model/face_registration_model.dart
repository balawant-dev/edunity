class FaceRegistrationModel {
  final bool status;
  final String message;
  final String profileId;
  final String registrationStatus;
  final int imageCount;
  final int primaryImageCount;

  FaceRegistrationModel({
    required this.status,
    required this.message,
    required this.profileId,
    required this.registrationStatus,
    required this.imageCount,
    required this.primaryImageCount,
  });

  // Factory constructor to create an instance from JSON
  factory FaceRegistrationModel.fromJson(Map<String, dynamic> json) {
    return FaceRegistrationModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      profileId: json['profile_id'] ?? '',
      registrationStatus: json['registration_status'] ?? 'pending',
      imageCount: json['image_count'] ?? 0,
      primaryImageCount: json['primary_image_count'] ?? 0,
    );
  }

  // Method to convert the object back to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'profile_id': profileId,
      'registration_status': registrationStatus,
      'image_count': imageCount,
      'primary_image_count': primaryImageCount,
    };
  }
}