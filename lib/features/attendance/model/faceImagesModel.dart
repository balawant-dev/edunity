class FaceImagesModel {
  bool? status;
  int? uid;
  List<PrimaryImages>? primaryImages;
  List<ReferenceImages>? referenceImages;
  int? primaryImageCount;
  int? referenceImageCount;

  FaceImagesModel(
      {this.status,
        this.uid,
        this.primaryImages,
        this.referenceImages,
        this.primaryImageCount,
        this.referenceImageCount});

  FaceImagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    uid = json['uid'];
    if (json['primary_images'] != null) {
      primaryImages = <PrimaryImages>[];
      json['primary_images'].forEach((v) {
        primaryImages!.add(new PrimaryImages.fromJson(v));
      });
    }
    if (json['reference_images'] != null) {
      referenceImages = <ReferenceImages>[];
      json['reference_images'].forEach((v) {
        referenceImages!.add(new ReferenceImages.fromJson(v));
      });
    }
    primaryImageCount = json['primary_image_count'];
    referenceImageCount = json['reference_image_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['uid'] = this.uid;
    if (this.primaryImages != null) {
      data['primary_images'] =
          this.primaryImages!.map((v) => v.toJson()).toList();
    }
    if (this.referenceImages != null) {
      data['reference_images'] =
          this.referenceImages!.map((v) => v.toJson()).toList();
    }
    data['primary_image_count'] = this.primaryImageCount;
    data['reference_image_count'] = this.referenceImageCount;
    return data;
  }
}

class PrimaryImages {
  int? fid;
  String? url;

  PrimaryImages({this.fid, this.url});

  PrimaryImages.fromJson(Map<String, dynamic> json) {
    fid = json['fid'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fid'] = this.fid;
    data['url'] = this.url;
    return data;
  }
}

class ReferenceImages {
  int? fid;
  String? url;

  ReferenceImages({this.fid, this.url});

  ReferenceImages.fromJson(Map<String, dynamic> json) {
    fid = json['fid'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fid'] = this.fid;
    data['url'] = this.url;
    return data;
  }
}
