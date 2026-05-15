class AboutUsModel {
  final bool status;
  final AboutData data;

  AboutUsModel({required this.status, required this.data});

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      status: json['status'] ?? false,
      data: AboutData.fromJson(json['data']),
    );
  }
}

class AboutData {
  final String title;
  final String body;

  AboutData({required this.title, required this.body});

  factory AboutData.fromJson(Map<String, dynamic> json) {
    return AboutData(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}