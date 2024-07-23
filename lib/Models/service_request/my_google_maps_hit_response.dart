
import '../../Configurations/Constants/PointLatLng.dart';

class MyGoogleMapsHitResponse {

  String? status;
  List<PointLatLng> points;
  String pointsString = '';
  String distance = '';
  num distanceInKm = 0;
  String duration = '';
  num durationInSec = 0;
  String duration_in_traffic = '';
  String? errorMessage;

  MyGoogleMapsHitResponse({this.status, this.points = const [], this.errorMessage = ""});
}