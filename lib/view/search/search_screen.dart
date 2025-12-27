import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/core/config/app_themes.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/view/common/bouncing_button.dart';
import 'package:seeya/view/search/search_list_item.dart';
import 'package:uuid/uuid.dart';

import '../../core/config/app_colors.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [


          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.blueGrey600,
                          width: 2,
                        ),
                        color: Colors.white,
                      ),
                      child: SvgPicture.asset("assets/image/ic_back.svg"),
                    ),
                  ),
                  const SizedBox(width: 4,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.blueGrey600,
                          width: 2,
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              focusNode: controller.focusNode,
                              maxLength: 20,
                              onSubmitted: (value) async {

                                if(value.trim().isEmpty) return;

                                await controller.historyManager.addSearchItem(
                                  SearchHistoryModel(
                                    keyword: value,
                                    isEvent: false,
                                    id: Uuid().v4()
                                  )
                                );

                                await controller.searchComplete(value);
                              },
                              decoration: InputDecoration(
                                counterText:'',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                contentPadding: EdgeInsets.only(left: 16,top: 0,bottom: 0,right: 0),
                                hintText: "search.bar_hint".tr,
                              ),
                              cursorColor: AppColors.primary400,
                              cursorWidth: 2,
                              autofocus: true,
                              controller: controller.textController,
                              style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100),
                            )
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.textController.clear();
                            },
                            child: SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey500, BlendMode.srcIn))
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),





          const SizedBox(height: 12,),





          Obx(() {

            if(controller.searchText.value.isEmpty){

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Text("search.recent".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey000),),
                            const Expanded(child: SizedBox()),
                            BouncingButton(
                              onTap: () async {
                                await controller.historyManager.clearSearchHistory();
                                await controller.setSearchHistoryData();
                              },
                              child: Text("search.clear".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.searchHistories.length,
                            itemBuilder: (context, index) => Obx((){

                              var searchHistory = controller.searchHistories[index];

                              return SearchListItem(
                                onTap: () async {

                                  await controller.historyManager.moveDuplicateToTop(searchHistory);

                                  if(searchHistory.isEvent){
                                    await controller.setSearchHistoryData();
                                    Get.toNamed(AppRouter.event_detail, arguments: searchHistory.id ?? 0);
                                    return;
                                  }

                                  await controller.searchComplete(searchHistory.keyword);
                                },
                                onDelete: () async {
                                  await controller.historyManager.removeSearchItem(searchHistory.id);
                                  await controller.setSearchHistoryData();
                                },
                                title: searchHistory.isEvent ? searchHistory.event_name ?? "" : "${controller.searchHistories[index].keyword}",
                                subTitle: searchHistory.place_name ?? "",
                                isEvent: searchHistory.isEvent,
                                isFromPref: true,
                              );

                            }),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );

            }else {

              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.searchMatchingHistories.length,
                          itemBuilder: (context, index) {

                            var matchingHistories = controller.searchMatchingHistories[index];

                            return SearchListItem(
                              onTap: () async {
                                await controller.historyManager.moveDuplicateToTop(matchingHistories);
                                await controller.searchComplete(matchingHistories.keyword);
                              },
                              onDelete: () {

                              },
                              title: matchingHistories.keyword,
                              subTitle: "",
                              isEvent: true,
                              isFromPref: true,
                            );
                          },
                        ),
                      ),
                
                      const Divider(height: 12,thickness: 12, color: AppColors.blueGrey800,),
                
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.searchResponseList.length,
                          itemBuilder: (context, index) {

                            var searchResponseEvent = controller.searchResponseList[index];

                            return SearchListItem(
                              onTap: () async {
                                await controller.historyManager.addSearchItem(
                                    SearchHistoryModel(
                                      keyword: "",
                                      isEvent: true,
                                      id: Uuid().v4(),
                                      event_id: searchResponseEvent.id,
                                      event_name: searchResponseEvent.eventName,
                                      place_name: searchResponseEvent.placeName,
                                    )
                                );
                                Get.toNamed(AppRouter.event_detail, arguments: searchResponseEvent.id);
                              },
                              onDelete: () {},
                              title: searchResponseEvent.eventName ?? "",
                              subTitle: searchResponseEvent.placeName,
                              isEvent: true,
                              isFromPref: false,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30,),
                
                    ],
                  ),
                ),
              );

            }

          },),




        ],
      ),
    );
  }

}
