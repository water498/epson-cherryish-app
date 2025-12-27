import 'dart:math';

import 'package:geolocator/geolocator.dart';

class GeoUtils {
  GeoUtils._();

  static double calculateDistance(Position userLatLong, double lat2, double lon2) {
    const earthRadius = 6371; // 지구 반지름 (단위: km)
    final dLat = _toRadians(lat2 - userLatLong.latitude);
    final dLon = _toRadians(lon2 - userLatLong.longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(userLatLong.latitude)) * cos(_toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

}