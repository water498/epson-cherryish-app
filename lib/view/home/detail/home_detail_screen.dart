import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_colors.dart';

import '../../../constants/app_router.dart';
import '../../../constants/app_secret.dart';
import '../../../controller/controllers.dart';
import '../../../utils/format_utils.dart';
import '../../common/vertical_slider.dart';

class HomeDetailScreen extends GetView<HomeDetailController> {
  const HomeDetailScreen({super.key});

  static const double sidePadding = 10;

  @override
  Widget build(BuildContext context) {

    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(

              children: [

                Container(
                  color: const Color(0xfff5f5f5),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: FractionallySizedBox(
                      heightFactor: 0.8,
                      widthFactor: 0.8,
                      child: Obx(() {
                        return CachedNetworkImage(imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.photoTemplate.value?.thumbnail_image_filepath}"),fit: BoxFit.contain,);
                      },),
                    ),
                  ),
                ),


                const SizedBox(height: 20,),



                Padding(
                  padding: const EdgeInsets.only(left: sidePadding, right: sidePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Obx(()=> Text("${controller.photoTemplate.value?.title}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),


                      Obx(() {
                        return  SizedBox(
                          height: deviceHeight * 0.2,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.photoLayouts.length,
                            itemBuilder: (context, index) => Obx((){
                              return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {

                                  },
                                  child: CachedNetworkImage(imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.photoLayouts[index].thumbnail_image_filepath}"), fit: BoxFit.contain)
                              );
                            }), separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(width: 20,);
                          },
                          ),
                        );
                      },),

                      const SizedBox(height: 10,),
                      const Divider(thickness: 0.3,color: Colors.grey,),

                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("게시일"),
                              Text("프레임 컷"),
                              Text("가격"),
                            ],
                          ),
                          const SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text("${FormatUtils.timestampToFormatString(controller.photoTemplate.value?.open_time, "MM월dd일 HH:mm")} ~ ${FormatUtils.timestampToFormatString(controller.photoTemplate.value?.close_time, "MM월dd일 HH:mm")}")),
                              Obx(() => Text("${(controller.photoFilters.length / controller.photoLayouts.length).toInt()}컷")),
                              Obx(() => Text("${controller.photoTemplate.value?.cost}원")),
                            ],
                          )
                        ],
                      ),



                      const SizedBox(height: 10,),
                      Obx(() => Text("${controller.photoTemplate.value?.sub_title}", style: TextStyle(fontSize: 14),)),


                      const SizedBox(height: 10,),
                      const Divider(thickness: 0.3,color: Colors.grey,),
                      const SizedBox(height: 10,),


                      SizedBox(
                        height: deviceHeight * 0.3,
                        child: Obx(() {
                          if(controller.isMapInitialized.value){
                            return NaverMap(
                              forceGesture: true,
                              options: const NaverMapViewOptions(

                              ),
                              onMapReady: (controller) {
                                this.controller.naverMapController = controller;
                                this.controller.setMapSettings();
                                Logger().d("naver map ready");
                              },
                            );
                          }else {
                            return CircularProgressIndicator();
                          }
                        },),
                      ),

                      Obx(() => Text("${controller.photoTemplate.value?.description}", style: TextStyle(fontSize: 14),)),


                    ],
                  ),
                ),



                SizedBox(height: deviceHeight * 0.2,),

              ],
            ),
          ),


          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() {
                  if(controller.showFAB.value){
                    return GestureDetector(
                      onTap: () {
                        controller.scrollController.animateTo(
                          0.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        margin: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: AppColors.grey500,
                          shape: BoxShape.circle
                        ),
                        child: const Icon(Icons.keyboard_double_arrow_up_rounded, color: Colors.white,),
                      ),
                    );
                  }else {
                    return Container();
                  }
                }),
                Container(
                  width: double.infinity,
                  color: AppColors.grey500,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextButton(onPressed: () {
                    Get.toNamed(
                        AppRouter.editorLayout,
                        arguments: {
                          "photo_template" : controller.photoTemplate.value,
                          "photo_layouts": controller.photoLayouts.toList(),
                          "photo_filters": controller.photoFilters.toList()
                        }
                    );
                  }, child: const SafeArea(
                    top: false,
                    bottom: true,
                    child: Text("사용하기", style: TextStyle(color: AppColors.main700),))
                  ),
                ),
              ],
            )
          ),


        ],
      ),
    );

  }

}
