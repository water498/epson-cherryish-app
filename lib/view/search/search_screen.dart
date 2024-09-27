import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/search/search_list_item.dart';

import '../../constants/app_colors.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {


    final controller = Get.put(SearchScreenController());



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
                              textInputAction: TextInputAction.done,
                              onSubmitted: (value) {
                                Get.back(result: "$value");
                              },
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                contentPadding: EdgeInsets.only(left: 16,top: 0,bottom: 0,right: 0),
                                hintText: "지역, 장소명, 테마로 찾아보세요.",
                              ),
                              cursorColor: AppColors.primary400,
                              cursorWidth: 2,
                              autofocus: true,
                              controller: controller.textController,
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
                            Text("최근 검색어", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey000),),
                            const Expanded(child: SizedBox()),
                            Text("전체 지우기", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return SearchListItem(onTap: () {
                                Get.back(result: "생일 카페 (keyword)");
                              },eventName: "생일 카페", isPlace: index % 2 == 0 ? true : false, isRecorded: true,);
                            },
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
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return SearchListItem(onTap: () {
                              Get.back(result: "result 22222222222222");
                            },eventName: "생일 카페", isPlace: true, isRecorded: true,);
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
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return SearchListItem(onTap: () {
                              Get.back(result: "result 33333333333333");
                            },eventName: "데일리 프롯", isPlace: true, isRecorded: false,);
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
