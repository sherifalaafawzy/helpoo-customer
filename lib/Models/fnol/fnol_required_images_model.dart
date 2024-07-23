class FnolRequiredImagesModel {
  String? status;
  List<String>? requiredImages;

  FnolRequiredImagesModel({this.status, this.requiredImages});

  FnolRequiredImagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requiredImages = json['requiredImages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['requiredImages'] = this.requiredImages;
    return data;
  }
}
