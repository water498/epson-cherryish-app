import 'package:logger/logger.dart';
import 'package:seeya/constants/app_prefs_keys.dart';
import 'package:seeya/data/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchHistoryManager {

  // 검색 기록 저장
  Future<void> saveSearchHistory(List<SearchHistoryModel> searchHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList = searchHistory.map((item) => jsonEncode(item.toJson())).toList();
    prefs.setStringList(AppPrefsKeys.searchHistory, encodedList);
  }

  // 검색 기록 불러오기
  Future<List<SearchHistoryModel>> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList(AppPrefsKeys.searchHistory);

    if (encodedList != null) {
      return encodedList.map((item) => SearchHistoryModel.fromJson(jsonDecode(item))).toList();
    }
    return [];
  }

  // 검색 기록 업데이트 (추가)
  Future<void> addSearchItem(SearchHistoryModel item) async {
    List<SearchHistoryModel> searchHistory = await loadSearchHistory();

    // check duplicate
    bool isDuplicate = false;
    if(item.isEvent){
      isDuplicate = searchHistory.any((history) => history.event_id == item.event_id);
    } else {
      isDuplicate = searchHistory.any((history) => history.keyword == item.keyword);
    }

    if (isDuplicate) {
      moveDuplicateToTop(item);
      return;
    }


    searchHistory.insert(0, item);
    await saveSearchHistory(searchHistory);
  }

  // 검색 기록 삭제
  Future<void> removeSearchItem(String id) async {
    List<SearchHistoryModel> searchHistory = await loadSearchHistory();
    searchHistory.removeWhere((item) => item.id == id);
    await saveSearchHistory(searchHistory);
  }

  // 검색 기록 초기화
  Future<void> clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(AppPrefsKeys.searchHistory);
  }


  // 중복되는 검색어 존재시 최상단으로 이동
  Future<void> moveDuplicateToTop (SearchHistoryModel item) async {
    List<SearchHistoryModel> searchHistory = await loadSearchHistory();

    int index = -1;
    if(item.isEvent){
      index = searchHistory.indexWhere((history) => history.event_id == item.event_id);
    } else {
      index = searchHistory.indexWhere((history) => history.keyword == item.keyword);
    }

    if (index != -1) {
      var existingItem = searchHistory.removeAt(index);
      searchHistory.insert(0, existingItem);
      await saveSearchHistory(searchHistory);
      return;
    }
  }

}