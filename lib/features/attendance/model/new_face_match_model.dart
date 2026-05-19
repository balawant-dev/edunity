class NewFaceMatchModel {
  bool? status;
  bool? match;
  double? confidence;
  double? distance;

  NewFaceMatchModel({this.status, this.match, this.confidence, this.distance});

  NewFaceMatchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    match = json['match'];
    confidence = json['confidence'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['match'] = this.match;
    data['confidence'] = this.confidence;
    data['distance'] = this.distance;
    return data;
  }
}
