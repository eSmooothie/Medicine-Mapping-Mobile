import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:math' as Math;

class Haversine {
  static final num R = 6371; // Earth's radius

  static double getDistanceInKm({
    required LatLng start,
    required LatLng end,
  }) {
    double startLatitude = start.latitude;
    double startLongitude = start.longitude;
    double endLatitude = end.latitude;
    double endLongitude = end.longitude;

    double distance = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distance / 1000;
  }

  static double getDistanceInM({
    required LatLng start,
    required LatLng end,
  }) {
    double startLatitude = start.latitude;
    double startLongitude = start.longitude;
    double endLatitude = end.latitude;
    double endLongitude = end.longitude;

    double distance = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distance;
  }

  static num degTorad(num deg) {
    return deg * (Math.pi / 180);
  }
}
