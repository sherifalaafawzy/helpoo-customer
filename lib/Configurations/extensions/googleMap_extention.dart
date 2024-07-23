import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:google_maps_webservice/places.dart' as googlemapswebservice;

extension LocationExtension on gm.LatLng {
  googlemapswebservice.Location get toGoogleLocation => googlemapswebservice.Location(lat: latitude, lng: longitude);
}
