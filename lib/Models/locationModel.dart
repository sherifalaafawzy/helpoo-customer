class LocationModel {
  double? lat;
  double? lng;
  String? address;
  String? name;

  LocationModel({this.lat, this.lng, this.address});

  LocationModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}
