class NewFaceMatchModel {
  bool? status;
  bool? match;
  double? confidence;
  double? distance;
  String? image1Url;
  String? image2Url;

  NewFaceMatchModel({this.status, this.match, this.confidence, this.distance,this.image1Url,this.image2Url});

  NewFaceMatchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    match = json['match'];
    confidence = json['confidence'];
    distance = json['distance'];
    image1Url = json['image1_url'];
    image2Url = json['image2_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['match'] = this.match;
    data['confidence'] = this.confidence;
    data['distance'] = this.distance;
    data['image1_url'] = this.image1Url;
    data['image2_url'] = this.image2Url;
    return data;
  }
}
