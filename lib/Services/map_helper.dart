import 'dart:math';

class MapHelper {
  static double calculateBearing(
      double lat1, double lon1, double lat2, double lon2) {
    double phi1 = _degreesToRadians(lat1);
    double phi2 = _degreesToRadians(lat2);

    double deltaLambda = _degreesToRadians(lon2 - lon1);

    double x = sin(deltaLambda) * cos(phi2);
    double y =
        cos(phi1) * sin(phi2) - (sin(phi1) * cos(phi2) * cos(deltaLambda));

    double bearing = atan2(x, y);

    // Convert bearing from radians to degrees
    bearing = _radiansToDegrees(bearing);

    // Normalize bearing to be in the range [0, 360)
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  static double _degreesToRadians(double degrees) => degrees * (pi / 180.0);

  static double _radiansToDegrees(double radians) => radians * (180.0 / pi);
}
