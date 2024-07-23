class MapPlaceDetailsModel {
  final String status;
  final MapPlaceDetailsDataModel result;

  MapPlaceDetailsModel({
    required this.status,
    required this.result,
  });

  factory MapPlaceDetailsModel.fromJson(Map<String, dynamic> json) {
    return MapPlaceDetailsModel(
      status: json['status'] ?? '',
      result: MapPlaceDetailsDataModel.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'result': result.toJson(),
    };
  }
}

class MapPlaceDetailsDataModel {
  final num latitude;
  final num longitude;
  final String address;

  MapPlaceDetailsDataModel({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory MapPlaceDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return MapPlaceDetailsDataModel(
      latitude: json['geometry']['location']['lat'] ?? 0.0,
      longitude: json['geometry']['location']['lng'] ?? 0.0,
      address: json['formatted_address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}