import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/utils/format_utils.dart';
import 'package:seeya/view/common/bouncing_button.dart';
import 'package:seeya/view/common/map_button.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          Obx(() {
            if(controller.isMapInitialized.value){
              return NaverMap(
                forceGesture: true,
                options: const NaverMapViewOptions(
                  logoAlign: NLogoAlign.leftTop,
                  logoMargin: EdgeInsets.only(left: 10,top: 10),
                  scaleBarEnable: false,
                ),
                onMapReady: (controller) {
                  this.controller.naverMapController = controller;
                  this.controller.fetchTemplateList();
                },
              );
            }else {
              return Container();
            }
          },),


          Positioned(
            top: 0,
            bottom: 100,
            right: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                MapButton(iconData: Icons.my_location, onTap: () {
                  controller.getCurrentLocation();
                },),
                const SizedBox(height: 15,),
                MapButton(iconData: Icons.refresh, onTap: () {
                  controller.fetchTemplateList();
                },),
              ],
            ),
          ),


          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [


              Obx(() {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: PageView.builder(
                    itemCount: controller.templateList.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    controller: controller.pageController,
                    onPageChanged: (value) {
                      final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
                        target: NLatLng(controller.templateList[value].latitude,controller.templateList[value].longitude),
                        zoom: controller.zoomLevel,
                      );
                      cameraUpdate.setAnimation(animation: NCameraAnimation.fly, duration: Duration(seconds: 1));
                      controller.naverMapController.updateCamera(cameraUpdate);
                      Logger().d("page changed value ::: $value");
                    },
                    itemBuilder: (context, index)  => Obx((){
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Get.toNamed(AppRouter.homeDetail, arguments: controller.templateList[index].uid);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ]
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CachedNetworkImage(imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.templateList[index].thumbnail_image_filepath}"),fit: BoxFit.contain,),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        stops: [0.5, 0.8, 1.0],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Color(0xffffffff),Color(0x40ffffff),Color(0x00ffffff)],
                                      )
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.7,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${controller.templateList[index].title}", style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                        Text("${controller.templateList[index].sub_title}", style: TextStyle(fontSize:13),overflow: TextOverflow.ellipsis),
                                        Text("${controller.templateList[index].address}", style: TextStyle(fontSize:13),overflow: null),
                                        Text("좋아요 ${controller.templateList[index].like_count}개", style: TextStyle(fontSize:11),overflow: TextOverflow.ellipsis),
                                        const Expanded(child: SizedBox()),
                                        Text("${FormatUtils.timestampToFormatString(controller.templateList[index].open_time, "MM월dd일 HH:mm")} ~ ${FormatUtils.timestampToFormatString(controller.templateList[index].close_time, "MM월dd HH:mm")}", style: TextStyle(fontSize:11),),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                        ),
                      );
                    }),
                  ),
                );
              },),


            ],
          ),


        ],
      ),
    );

  }

}
