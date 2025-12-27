import 'dart:math';

class CalculateUtils {
  CalculateUtils._();

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371000; // 지구의 반지름, 단위: meter
    final double dLat = (lat2 - lat1) * (pi / 180.0);
    final double dLon = (lon2 - lon1) * (pi / 180.0);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180.0)) * cos(lat2 * (pi / 180.0)) *
            sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c; // 거리 반환 (미터 단위)
  }

}