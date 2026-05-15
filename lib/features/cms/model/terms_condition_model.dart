class TermsConditionModel {
  final bool status;
  final TermsData data;

  TermsConditionModel({required this.status, required this.data});

  factory TermsConditionModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionModel(
      status: json['status'] ?? false,
      data: TermsData.fromJson(json['data']),
    );
  }
}

class TermsData {
  final String title;
  final String body;

  TermsData({required this.title, required this.body});

  factory TermsData.fromJson(Map<String, dynamic> json) {
    return TermsData(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}