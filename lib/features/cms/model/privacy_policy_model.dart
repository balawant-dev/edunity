class PrivacyPolicyModel {
  final bool status;
  final PrivacyData data;

  PrivacyPolicyModel({required this.status, required this.data});

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      status: json['status'] ?? false,
      data: PrivacyData.fromJson(json['data']),
    );
  }
}

class PrivacyData {
  final String title;
  final String body;

  PrivacyData({required this.title, required this.body});

  factory PrivacyData.fromJson(Map<String, dynamic> json) {
    return PrivacyData(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}