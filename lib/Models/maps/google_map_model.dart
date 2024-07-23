import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsModel {
  LatLng? destination;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
}