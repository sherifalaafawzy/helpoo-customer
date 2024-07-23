
class Driver {
  int? id;
  String? name;
  String? phoneNumber;
  String? averageRating;
  String? fcmToken;
  int? ratingCount;
  double? lat;
  double? lng;
  double? heading;
  String? photo;
  Distance? distance;

  Driver({
    this.id,
    this.name,
    this.phoneNumber,
    this.averageRating,
    this.fcmToken,
    this.ratingCount,
    this.lat,
    this.lng,
    this.heading,
    this.photo,
    this.distance,
  });

  factory Driver.fromJson(Map json, {bool isFromCurrentReqResponse = false}) {
    if (isFromCurrentReqResponse) {

      return Driver(
        id: json['id'],
        name: json['User']['name'] ?? 'name',
        phoneNumber: json['User']['PhoneNumber'] ?? '123456789',
        averageRating: json['average_rating'],
        ratingCount: json['rating_count'],
        fcmToken: json['fcmtoken'] ?? '12346',
        lat: json['location']['latitude'] ?? 0.0,
        lng: json['location']['longitude'] ?? 0.0,
        heading: double.tryParse(json['location']['heading']??0.0),
        photo: json['User']['photo'] ??
            "https://pixinvent.com/demo/materialize-mui-react-nextjs-admin-template/demo-1/images/avatars/1.png",
      );
    } else {
      return Driver(
        id: json['driver']['id'],
        name: json['driver']['name'],
        phoneNumber: json['driver']['phoneNumber'],
        averageRating: json['driver']['averageRating'],
        ratingCount: json['driver']['ratingCount'],
        fcmToken: json['driver']['fcmtoken'],
        lat: json['driver']['lat'],
        lng: json['driver']['lng'],
        heading: double.tryParse(json['driver']['heading']??0.0),
        photo: json['driver']['photo'],
        distance: json['distance'] != null ? Distance.fromJson(json['distance']) : null,
      );
    }
  }
}


class GetDriverResponse {
  final String status;
  final String? msg;
  final Map? driverJson;
  final Map? distance;

  GetDriverResponse(
      {required this.status, required this.msg, required this.driverJson, required this.distance});
}



class Distance {
  SubDistance? distance;
  SubDistance? duration;
  String? status;

  Distance({this.distance, this.duration});

  Distance.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null ? SubDistance.fromJson(json['distance']) : null;
    duration = json['duration'] != null ? SubDistance.fromJson(json['duration']) : null;
    // status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.distance != null) {
      data['distance'] = this.distance!.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration!.toJson();
    }
    // data['status'] = this.status;
    return data;
  }
}

class SubDistance {
  String? text;
  int? value;

  SubDistance({this.text, this.value});

  SubDistance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}