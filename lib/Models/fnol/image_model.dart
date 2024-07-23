class ImageModel {
  String? text;
  String? imagePath;

  ImageModel({this.text, this.imagePath});

  ImageModel.fromJson(Map<String, dynamic> json) {
    text = json['text'] != null ? json['text'] : '';
    imagePath = json['imagePath'] != null ? json['imagePath'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.imagePath;
    data['text'] = this.text;
    return data;
  }
}
