import 'dart:math';

import '../../data/model/models.dart';

abstract class SeeyaFrameConfigs {
  SeeyaFrameConfigs._();

  static const frameWidth = 1920.0;
  static const frameHeight = 2880.0;
  static const filterWidth = 786.0;
  static const filterHeight = 1064.0;

  // 좌상단 좌표
  static Point getFilterXY(String frameType, String filterType) {
    final Map<String, Point> typeAMap = {
      "lt": Point(134, 230),
      "lb": Point(134, 1356),
      "rt": Point(1000, 230),
      "rb": Point(1000, 1356),
    };

    final Map<String, Point> typeBMap = {
      "lt": Point(134, 230),
      "lb": Point(134, 1356),
      "rt": Point(1000, 460),
      "rb": Point(1000, 1586),
    };

    final Map<String, Point> typeCMap = {
      "lt": Point(134, 460),
      "lb": Point(134, 1586),
      "rt": Point(1000, 230),
      "rb": Point(1000, 1356),
    };

    final Map<String, Point> typeDMap = {
      "lt": Point(134, 460),
      "lb": Point(134, 1586),
      "rt": Point(1000, 460),
      "rb": Point(1000, 1586),
    };

    final Map<String, Point> typeEMap = {
      "lt": Point(134, 344),
      "lb": Point(134, 1470),
      "rt": Point(1000, 344),
      "rb": Point(1000, 1470),
    };

    switch (frameType) {
      case "type_a":
        return typeAMap[filterType] ?? Point(0, 0);
      case "type_b":
        return typeBMap[filterType] ?? Point(0, 0);
      case "type_c":
        return typeCMap[filterType] ?? Point(0, 0);
      case "type_d":
        return typeDMap[filterType] ?? Point(0, 0);
      case "type_e":
        return typeEMap[filterType] ?? Point(0, 0);
      default:
        return Point(0, 0);
    }
  }

}