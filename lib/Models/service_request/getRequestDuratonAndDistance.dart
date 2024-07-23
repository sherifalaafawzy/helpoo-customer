import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetRequestDurationAndDistanceDTO {
  int? serviceRequestId;
  String? oldStatus;
  LatLng driverLatLng;
  LatLng curClientLocation;
  LatLng? prevClientLocation;
  LatLng? oldDest;

  GetRequestDurationAndDistanceDTO({
    this.serviceRequestId,
    this.oldStatus,
    required this.driverLatLng,
    required this.curClientLocation,
    this.prevClientLocation,
    this.oldDest,
  });

  Map<String, dynamic> toJson() => {
        "reqId": serviceRequestId,
        "status": oldStatus ?? "",
        "driverLocation": {
          "lat": driverLatLng.latitude,
          "lng": driverLatLng.longitude
        },
        "curClientLocation": {
          "lat": curClientLocation.latitude,
          "lng": curClientLocation.longitude
        },
        "prevClientLocation": prevClientLocation != null
            ? {
                "lat": prevClientLocation!.latitude,
                "lng": prevClientLocation!.longitude
              }
            : null,
        "oldDest": oldDest != null
            ? {"lat": oldDest!.latitude, "lng": oldDest!.longitude}
            : null,
        "from": "mobile",
      };
}
