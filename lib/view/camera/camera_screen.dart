import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/bouncing_button.dart';

import '../../constants/app_router.dart';
import '../../data/model/models.dart';

class CameraScreen extends GetView<CameraScreenController> {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGrey000,
      appBar: AppBar(
        backgroundColor: AppColors.blueGrey000,
        leadingWidth: 64,
        leading: Obx(() {

          var mergedPhoto = controller.frameController.mergedPhotoList[controller.currentPage.value];

          if(mergedPhoto == null){
            return Row(
              children: [
                const SizedBox(width: 16,),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),)
                ),
              ],
            );
          }else {
            return const SizedBox();
          }
        },),
        actions: [
          Obx(() {

            var mergedPhoto = controller.frameController.mergedPhotoList[controller.currentPage.value];

            return GestureDetector(
                onTap: () {
                  mergedPhoto == null ? controller.switchingCamera() : Get.back();
                },
                child: SvgPicture.asset("assets/image/${mergedPhoto == null ? "ic_swap" : "ic_close"}.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),)
            );
          },),
          const SizedBox(width: 16,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [



                  // Camera
                  Obx(() {

                    if(controller.isInitialized.value){

                      var curFilter = controller.frameController.eventFilterList[controller.currentPage.value];

                      return AspectRatio(
                          aspectRatio: curFilter.width/curFilter.height,
                          child: ClipRect(
                            child: Transform.scale(
                              scale: curFilter.height/curFilter.width,
                              child: Center(
                                child: CameraPreview(controller.cameraController!)
                              ),
                            ),
                          )
                      );
                    }else {
                      return Container(color: Colors.black);
                    }
                  }),



                  // Filter
                  Obx(() {
                    if(controller.isInitialized.value){

                      var curFilter = controller.frameController.eventFilterList[controller.currentPage.value];

                      if(curFilter.imageFilepath == null) return const SizedBox();

                      return AspectRatio(
                        aspectRatio: curFilter.width/curFilter.height,
                        child: CachedNetworkImage(
                          imageUrl: Uri.encodeFull("${AppSecret.s3url}${curFilter.imageFilepath}"),
                          fit: BoxFit.fill
                        ),
                      );
                    }else {
                      return const SizedBox();
                    }
                  },),




                  // captured image
                  Obx(() {

                    var mergedPhoto = controller.frameController.mergedPhotoList[controller.currentPage.value];

                    if(mergedPhoto == null){
                      return const SizedBox();
                    }

                    var key = ValueKey(mergedPhoto.file.lastModifiedSync().toIso8601String());
                    Logger().d("key ::: $key");
                    var curFilter = controller.frameController.eventFilterList[controller.currentPage.value];

                    return Container(
                      color: AppColors.blueGrey000,
                      child: AspectRatio(
                        aspectRatio: curFilter.width/curFilter.height,
                        child: Image.file(
                          mergedPhoto.file,
                          fit: BoxFit.contain,
                          key: ValueKey(mergedPhoto.file.lastModifiedSync().toIso8601String()),
                        )
                      ),
                    );
                  },)





                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: PageView.builder (
              controller: controller.pageController,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Obx((){
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    controller.pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.linear);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text("내부 필터 ${index+1}", style: AppThemes.bodyMedium.copyWith(color: controller.currentPage.value == index ? Colors.white : AppColors.blueGrey300),),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16,),
          SafeArea(
            child: Obx(() {

              var mergedPhoto = controller.frameController.mergedPhotoList[controller.currentPage.value];

              if(mergedPhoto == null){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 30,),
                        GestureDetector(
                          onTap: () async {

                            var xFile = await controller.pickImage();
                            if(xFile != null){
                              var result = await Get.toNamed(AppRouter.image_crop, arguments: {
                                "selected_image":xFile,
                                "filter":controller.currentFilter
                              });

                              if (result != null && result is File){
                                var model = CameraResultModel(filter_uid: controller.currentFilter.uid, file: result);
                                Logger().d("controller.currentPage.value ::: ${controller.currentPage.value}");
                                controller.frameController.mergedPhotoList[controller.currentPage.value] = model;
                              }
                            }


                          },
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Obx(() {
                              var latestPhoto = controller.latestPhoto.value;

                              if(latestPhoto != null){
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                  child: Image.memory(controller.latestPhoto.value!, fit: BoxFit.cover,),
                                );
                              }else {
                                return SvgPicture.asset("assets/image/ic_album.svg");
                              }
                            },),
                          ),
                        ),
                      ],
                    ),
                    BouncingButton(
                        onTap: () {
                          var clickedIndex = controller.currentPage.value;
                          controller.takePicture(clickedIndex);
                        },
                        child: Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              )
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                    ),
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: false,
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          const SizedBox(width: 30,),
                        ],
                      ),
                    ),
                  ],
                );
              }else {
                return SizedBox(
                  height: 84,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              var clickedIndex = controller.currentPage.value;
                              var file = controller.frameController.mergedPhotoList[clickedIndex]?.file;
                              if(file != null){
                                await controller.deleteImageFile(file);
                                controller.frameController.mergedPhotoList[clickedIndex] = null;
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color : AppColors.primary000,
                                border: Border.all(
                                  color: AppColors.primary400,
                                  width: 2,
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text("삭제", style: AppThemes.headline05.copyWith(color: AppColors.primary400),textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color : AppColors.primary400.withOpacity(0.8),
                                  border: Border.all(
                                    color: AppColors.primary400,
                                    width: 2,
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text("완료", style: AppThemes.headline05.copyWith(color: Colors.white),textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            },)
          ),
          const SizedBox(height: 23,),
        ],
      )
    );
  }

}


