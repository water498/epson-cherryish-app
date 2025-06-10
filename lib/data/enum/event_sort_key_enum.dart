import 'package:get/get.dart';

enum EventSortKeyEnum {
  popular,  // 인기 순
  distance, // 거리 순
  // relevance // 관련도 순
}

class EventSortKeyHelper {
  // SortOption에 따라 문자열을 반환하는 함수
  static String getSortOptionString(EventSortKeyEnum option) {
    switch (option) {
      case EventSortKeyEnum.popular:
        return "map_sort.popular".tr;
      case EventSortKeyEnum.distance:
        return "map_sort.distance".tr;
      // case EventSortKeyEnum.relevance:
      //   return "관련도 순";
      default:
        return "map_sort.unknown".tr;
    }
  }

  // 모든 SortOption을 문자열로 변환한 List를 반환하는 함수
  static List<String> getSortOptionList() {
    return EventSortKeyEnum.values.map((option) => getSortOptionString(option)).toList();
  }
}

extension EventSortKeyExtension on EventSortKeyEnum {
  String toDisplayString() {
    switch (this) {
      case EventSortKeyEnum.popular:
        return "map_sort.popular".tr;
      case EventSortKeyEnum.distance:
        return "map_sort.distance".tr;
      // case EventSortKeyEnum.relevance:
      //   return "관련도 순";
      default:
        return "map_sort.unknown".tr;
    }
  }

}
