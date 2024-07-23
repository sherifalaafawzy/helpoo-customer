import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetDistanceAndDurationResponse {
  String? status;
  DistanceAndDuration? distanceAndDuration;

  GetDistanceAndDurationResponse({this.status, this.distanceAndDuration});

  GetDistanceAndDurationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    distanceAndDuration = json['distanceAndDuration'] != null
        ? new DistanceAndDuration.fromJson(json['distanceAndDuration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.distanceAndDuration != null) {
      data['distanceAndDuration'] = this.distanceAndDuration!.toJson();
    }
    return data;
  }
}

class DistanceAndDuration {
  DriverDistanceMatrix? driverDistanceMatrix;
  List<LatLng>? points;
  bool? move;
  int? moveAfter;

  DistanceAndDuration({this.driverDistanceMatrix, this.points, this.move,this.moveAfter});

  DistanceAndDuration.fromJson(Map<String, dynamic> json) {
    driverDistanceMatrix = json['driverDistanceMatrix'] != null
        ? new DriverDistanceMatrix.fromJson(json['driverDistanceMatrix'])
        : null;
    if (json['points'] != null) {
      points = [];
      // json['points'].forEach((v) {
      //   points!.add(new List.fromJson(v));
      // });
      points = _convertToLatLng(json['points']);
    }
    move=json['move'];
    moveAfter=json['moveAfter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, List<LatLng>>();
    if (this.driverDistanceMatrix != null) {
      data['driverDistanceMatrix'] = this.driverDistanceMatrix!.toJson();
    }
    if (this.points != null) {
      // data['points'] = this.points!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<LatLng> _convertToLatLng(List points) {
    List<LatLng> latLngList = [];

    for (var coordinates in points) {
      double lat = coordinates[0];
      double lng = coordinates[1];
      latLngList.add(LatLng(lat, lng));
    }
    return latLngList;
  }
}

class DriverDistanceMatrix {
  Distance? distance;
  Distance? duration;

  DriverDistanceMatrix({this.distance, this.duration});

  DriverDistanceMatrix.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? new Distance.fromJson(json['duration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distance != null) {
      data['distance'] = this.distance!.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration!.toJson();
    }
    return data;
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}
