class DecodedPoints {
  String status;
  List<List<double>> encodedString;

  DecodedPoints({
    required this.status,
    required this.encodedString,
  });

  factory DecodedPoints.fromJson(Map<String, dynamic> json) {
    return DecodedPoints(
      status: json['status'],
      // encodedString: json['encodedString'] != null
      //     ? (json['encodedString'] as List)
      //         .map((e) => (e as List).map((e) => e.toDouble()).toList())
      //         .toList()
      //     : [],
      encodedString: _convertToDouble(json['encodedString']),
    );
  }

  static List<List<double>> _convertToDouble(List points) {
    List<List<double>> result = [];
    for (var point in points) {
      result.add([point[0].toDouble(), point[1].toDouble()]);
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'encodedString': encodedString,
    };
  }
}

// class DecodedPointsDetails {
//   double lat;
//   double lng;
//
//   DecodedPointsDetails({
//     required this.lat,
//     required this.lng,
//   });
//
//   factory DecodedPointsDetails.fromJson(Map<String, dynamic> json) {
//     return DecodedPointsDetails(
//       lat: json['lat'],
//       lng: json['lng'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'lat': lat,
//       'lng': lng,
//     };
//   }
// }
