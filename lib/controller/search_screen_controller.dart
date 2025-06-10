import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/data/repository/repositories.dart';

import '../view/search/search_history_manager.dart';

class SearchScreenController extends GetxController{

  final SearchScreenRepository searchScreenRepository;

  SearchScreenController({required this.searchScreenRepository});



  late final TextEditingController textController;
  late FocusNode focusNode;
  var searchText = ''.obs;
  late Function() textListener;
  SearchHistoryManager historyManager = SearchHistoryManager();
  RxList<SearchHistoryModel> searchHistories = <SearchHistoryModel>[].obs; // 전체 검색 기록
  RxList<SearchHistoryModel> searchMatchingHistories = <SearchHistoryModel>[].obs; // Keyword에 필터링된 검색 기록
  RxList<SearchResponseModel> searchResponseList = <SearchResponseModel>[].obs;



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
      await fetchSearchResult(textController.text);

      // 내 검색 기록 필터링
      searchMatchingHistories.value = searchHistories
          .where((item) => item.keyword.contains(textController.text))
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

    try {

      print("keyword $searchKeyword");

      CommonResponseModel commonResponse = await searchScreenRepository.searchEventsFromKeywordApi(searchKeyword);

      if(commonResponse.successModel != null){
        List<SearchResponseModel> response = SearchResponseModel.fromJsonList(commonResponse.successModel!.content["items"]);
        searchResponseList.value = response;

      } else if(commonResponse.failModel != null) {
        throw Exception();
      }

    } catch (e, stackTrace) {
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    } finally {

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