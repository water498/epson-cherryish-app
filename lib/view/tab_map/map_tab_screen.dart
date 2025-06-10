import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/data/enum/event_sort_key_enum.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/view/common/bouncing_button.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_themes.dart';
import '../../controller/controllers.dart';
import '../../utils/format_utils.dart';
import '../dialog/dialogs.dart';

class MapTabScreen extends GetView<MapTabController> {

  static const double minHeightPercent = 0.4;

  const MapTabScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide > 600;

    return Scaffold(
      body: Stack(
        children: [

          Obx(() {
            if(controller.isMapInitialized.value && controller.isEventListFetched.value){
              return NaverMap(
                forceGesture: true,
                options: const NaverMapViewOptions(
                  logoAlign: NLogoAlign.leftTop,
                  logoMargin: EdgeInsets.only(left: 20,top: kToolbarHeight + 35),
                  logoClickEnable: false,
                  scaleBarEnable: false,
                ),
                onMapReady: (controller) {
                  this.controller.naverMapController = controller;
                  this.controller.setMapData(context);
                },
              );
            }else {
              return const SizedBox();
            }
          },),




          Column(
            children: [

              // 메인 컨텐츠
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.openSearch();
                          },
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
                                const SizedBox(width: 16,),
                                Expanded(child: Obx(() => Text(controller.searchResult.value.isEmpty ? "map.search_hint".tr : controller.searchResult.value, style: AppThemes.bodyMedium.copyWith(color: controller.searchResult.value.isEmpty ? AppColors.blueGrey600 : AppColors.blueGrey100, height: 1), overflow: TextOverflow.ellipsis, maxLines: 1,),)),
                                GestureDetector(
                                  onTap: () {
                                    if(controller.searchResult.value.isNotEmpty){
                                      controller.searchResult.value = "";
                                      controller.selectedClusterMarker([]);
                                      controller.curEventList.value = controller.allEventList;
                                      controller.updateMarker();
                                    }
                                  },
                                  child: Obx(() {
                                    if(controller.searchResult.value.isNotEmpty){
                                      return SvgPicture.asset("assets/image/ic_close.svg");
                                    }else {
                                      return IgnorePointer(child: SvgPicture.asset("assets/image/ic_search.svg"));
                                    }
                                  },),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),




              // 커스텀 시트
              Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {

                    return Obx(() {

                      controller.updateHeightOnce(constraints.maxHeight, minHeightPercent);

                      if(controller.sheetHeight.value == null) return const SizedBox();

                      var sheetHeight = controller.sheetHeight.value!;

                      return Stack(
                        children: [

                          Positioned(
                            left: 20,
                            bottom: controller.selectedClusterMarker.isEmpty ? controller.minHeight + 20 : controller.minHeight + 100,
                            child: BouncingButton(
                              onTap: () {
                                controller.getCurrentLocation();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.blueGrey600,
                                    width: 2,
                                  ),
                                  color: Colors.white,
                                ),
                                child: SvgPicture.asset("assets/image/ic_location.svg"),
                              ),
                            ),
                          ),


                          Obx(() {

                            if(controller.selectedClusterMarker.isEmpty) {
                              /// 선택된 클러스터 마커 없는경우
                              return AnimatedPositioned(
                                duration: const Duration(milliseconds: 100),
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: sheetHeight,
                                child: GestureDetector(
                                  onVerticalDragUpdate: (details) {
                                    var newHeight = sheetHeight -= details.primaryDelta!;
                                    if (newHeight < controller.minHeight) newHeight = controller.minHeight; // 최소 크기 제한
                                    if (newHeight > constraints.maxHeight) newHeight = constraints.maxHeight;

                                    controller.sheetHeight.value = newHeight;
                                  },
                                  onVerticalDragEnd: (details) {
                                    double velocity = details.primaryVelocity ?? 0.0;

                                    if (velocity > 500) {
                                      controller.sheetHeight.value = controller.minHeight;
                                    } else if (velocity < -500) {
                                      controller.sheetHeight.value = constraints.maxHeight;
                                    } else {
                                      if (sheetHeight > constraints.maxHeight * ((1 + minHeightPercent) / 2)) {
                                        controller.expandSheet();
                                      } else {
                                        controller.collapseSheet();
                                      }
                                    }

                                  },
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [

                                        const Divider(height: 2, thickness: 2, color: AppColors.blueGrey600,),
                                        const SizedBox(height: 10,),
                                        Container(
                                          width: 40,
                                          height: 4,
                                          color: AppColors.blueGrey600,
                                        ),
                                        const SizedBox(height: 4,),

                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                          child: Row(
                                            children: [
                                              Obx(() {
                                                if(controller.searchResult.value.isNotEmpty) return const SizedBox();
                                                return Text("map.event_list_title".tr, style: AppThemes.headline05,);
                                              },),
                                              Obx(() {
                                                if(controller.searchResult.value.isNotEmpty) return const SizedBox();
                                                return const Expanded(child: SizedBox());
                                              },),
                                              Obx(() {
                                                if(!controller.isMapInitialized.value) return const SizedBox();

                                                if(controller.curEventList.isEmpty){
                                                  return Expanded(
                                                    child: Container(
                                                      margin: const EdgeInsets.only(top: 30),
                                                      child: Center(
                                                        child: Text("map.event_list_empty".tr)
                                                      ),
                                                    ),
                                                  );
                                                }else {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return SortKeyListBottomSheet(onSelected: (sortKeyEnum) async {

                                                            if(sortKeyEnum == EventSortKeyEnum.distance){
                                                              bool noError = await controller.getCurrentLocation();
                                                              if(!noError) {
                                                                controller.searchSortKey.value = EventSortKeyEnum.popular;
                                                                Fluttertoast.showToast(msg: "map.toast.location_error".tr);
                                                                return;
                                                              }
                                                            }

                                                            if(sortKeyEnum == EventSortKeyEnum.popular){
                                                              controller.sortEventsByPopularity(controller.curEventList);
                                                            }

                                                          },);
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: AppColors.blueGrey700,
                                                            width: 2,
                                                          )
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Obx(() => Text(EventSortKeyHelper.getSortOptionString(controller.searchSortKey.value), style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey100),),),
                                                          SvgPicture.asset("assets/image/ic_arrow_down.svg")
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics: const ClampingScrollPhysics(),
                                            itemCount: controller.curEventList.length,
                                            itemBuilder: (context, index) {


                                              var event = controller.curEventList[index];


                                              return GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onTap: () {
                                                  Get.toNamed(AppRouter.event_detail, arguments: event.id);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                                  height: isTablet ? 180 : 150,
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(height: 20,),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: AppColors.blueGrey200,
                                                                    width: 2,
                                                                  )
                                                              ),
                                                              child: AspectRatio(
                                                                  aspectRatio: 1,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl: Uri.encodeFull("${AppSecret.s3url}${event.thumbnail_image_filepath}"),
                                                                    fit: BoxFit.cover,
                                                                  )
                                                              ),
                                                            ),
                                                            const SizedBox(width: 12,),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(event.event_name, style: AppThemes.headline05.copyWith(color: AppColors.blueGrey100), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                                  Text(event.place_name, style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300), overflow: TextOverflow.ellipsis, maxLines: 2,),
                                                                  const Expanded(child: SizedBox()),
                                                                  Text("map.event_list_item_period".trParams({'start_date':FormatUtils.formatDate01(event.start_date) ?? "", 'end_date':FormatUtils.formatDate01(event.end_date) ?? ""}), style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300)),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 20,),
                                                      const Divider(height: 1,thickness: 1,color: AppColors.blueGrey800,)
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );

                            } else {

                              /// 선택된 클러스터링 마커가 있는경우

                              return Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: sheetHeight + 80,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      const Divider(height: 2, thickness: 2, color: AppColors.blueGrey600,),
                                      const SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(controller.selectedClusterMarker[0].place_name, style: AppThemes.headline04.copyWith(color: AppColors.blueGrey000),),
                                            const Expanded(child: SizedBox()),
                                            GestureDetector(
                                                onTap: (){
                                                  controller.selectedClusterMarker([]);
                                                  controller.updateMarker();
                                                },
                                                child: SvgPicture.asset("assets/image/ic_close.svg")
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: controller.selectedClusterMarker.length,
                                          itemBuilder: (context, index) {

                                            var event = controller.selectedClusterMarker[index];

                                            return Padding(
                                              padding: EdgeInsets.only(left: index == 0 ? 24 : 6, right: index == controller.selectedClusterMarker.length - 1 ? 24 : 6),
                                              child: GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onTap: () {
                                                  Get.toNamed(AppRouter.event_detail, arguments: event.id);
                                                },
                                                child: Container(
                                                  width: sheetHeight - 80,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: AspectRatio(
                                                          aspectRatio: 1,
                                                          child: CachedNetworkImage(imageUrl: Uri.encodeFull("${AppSecret.s3url}${event.thumbnail_image_filepath}"),fit: BoxFit.cover,),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 12,),
                                                      Align(alignment: Alignment.centerLeft,child: Text(event.event_name, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100),maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, )),
                                                      Align(alignment: Alignment.centerLeft,child: Text("${FormatUtils.formatDate01(event.start_date)} - ${FormatUtils.formatDate01(event.end_date)}", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300), textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                                      const SizedBox(height: 30,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                            }
                          },),

                        ],
                      );



                    },);
                  },)
              ),

            ],
          ),




        ],
      ),
    );
  }

}

