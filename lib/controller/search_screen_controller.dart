import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/data/model/event/event.dart';
import 'package:seeya/core/data/repository/event_repository.dart';

// v1 (deprecated)
// import 'package:seeya/data/model/models.dart';
// import 'package:seeya/data/repository/repositories.dart';
import '../data/model/models.dart'; // SearchHistoryModel만 사용
import '../view/search/search_history_manager.dart';

class SearchScreenController extends GetxController{

  final eventRepository = EventRepository();



  late final TextEditingController textController;
  late FocusNode focusNode;
  var searchText = ''.obs;
  late Function() textListener;
  SearchHistoryManager historyManager = SearchHistoryManager();
  RxList<SearchHistoryModel> searchHistories = <SearchHistoryModel>[].obs; // 전체 검색 기록
  RxList<SearchHistoryModel> searchMatchingHistories = <SearchHistoryModel>[].obs; // Keyword에 필터링된 검색 기록
  RxList<Event> searchResponseList = <Event>[].obs;



  @override
  void onInit() {
    setSearchHistoryData();
    textController = TextEditingController();
    focusNode = FocusNode();
    textListener = () async {

      // 키워드 저장
      searchText.value = textController.text;

    };
    textController.addListener(textListener);

    // 검색 api
    debounce(searchText, (keyword) async {
      // 검색어가 비어있거나 공백만 있으면 API 호출하지 않음
      if (keyword.trim().isEmpty) {
        searchResponseList.value = []; // 결과 초기화
        searchMatchingHistories.value = []; // 검색 기록도 초기화
        return;
      }

      await fetchSearchResult(textController.text);

      // 내 검색 기록 필터링
      searchMatchingHistories.value = searchHistories
          .where((item) => item.keyword.isNotEmpty && item.keyword.contains(textController.text))
          .toList();
    }, time: const Duration(milliseconds: 50));

    super.onInit();
  }

  Future<void> setSearchHistoryData() async {
    searchHistories.value = await historyManager.loadSearchHistory();
  }

  @override
  void onClose() {
    super.onClose();
    textController.removeListener(textListener);
    textController.dispose();
    focusNode.dispose();
  }





  Future<void> fetchSearchResult(String searchKeyword) async {
    // 이중 검증: 공백 확인
    if (searchKeyword.trim().isEmpty) {
      searchResponseList.value = [];
      return;
    }

    try {

      print("keyword $searchKeyword");

      // v2 API
      List<Event> response = await eventRepository.searchEvents(searchKeyword);
      searchResponseList.value = response;

    } catch (e, stackTrace) {
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    }

  }



  Future<void> searchComplete(String keyword) async {
    await fetchSearchResult(keyword);

    List<int> searchResultEventIds = searchResponseList.map((element) => element.id,).toList();
    String eventIds = searchResultEventIds.join(",");

    Get.back(result: {
      "keyword" : keyword,
      "event_ids" : eventIds,
    });
  }







}