class LocationAddress {
  // int? id;
  double? lat;
  double? lng;
  String? address;
  String? name;

  LocationAddress.fromJson(json) {
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}
