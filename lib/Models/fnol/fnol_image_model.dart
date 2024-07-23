class FnolImageModel {
  bool? additional;
  String? imageName;
  String? image;

  FnolImageModel({this.additional, this.imageName, this.image});

  FnolImageModel.fromJson(Map<String, dynamic> json) {
    additional = json['additional'] != null ? json['additional'] : false;
    imageName = json['imageName'] != null ? json['imageName'] : '';
    image = json['image'] != null ? json['image'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['additional'] = this.additional;
    data['imageName'] = this.imageName;
    data['image'] = this.image;
    return data;
  }
}
