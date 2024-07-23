class MapPlaceDetailsCoordinatesModel {
  final String placeName;

  MapPlaceDetailsCoordinatesModel({
    required this.placeName,
  });

  factory MapPlaceDetailsCoordinatesModel.fromJson(Map<String, dynamic> json) {
    List result = json['results'];

    dynamic item = result.firstWhere((element) => element['geometry']['location_type'] == 'APPROXIMATE');

    return MapPlaceDetailsCoordinatesModel(
      placeName: item['formatted_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
    };
  }
}
