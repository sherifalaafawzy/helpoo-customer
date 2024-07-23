class ImagesModel {
  int? id;
  String? imageName;
  String? imagePath;
  bool? additional;
  DateTime? date;


  ImagesModel.fromJson(Map json) {
    id = json['id'];
    imageName = json['imageName'];
    imagePath = json['imagePath'];
    if (json['additional'] != null) {
      additional = json['additional'];
    }
    if (json['createdAt'] != null) {
      date = DateTime.parse(json['createdAt']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? 0;
    data['imageName'] = this.imageName ?? '';
    data['imagePath'] = this.imagePath ?? '';
    data['additional'] = this.additional ?? false;
    data['createdAt'] = this.date ?? DateTime.now();
    return data;
  }
}
