import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/data/model/home_detail_model.dart';
import 'package:seeya/view/common/vertical_slider.dart';

import '../../../../constants/app_router.dart';
import '../../../../controller/controllers.dart';
import '../../../common/common_dialog.dart';


class EditorLayoutScreen extends GetView<EditorLayoutController> {
  const EditorLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.grey500,
      appBar: AppBar(
        title: Text(controller.photoTemplate.title, overflow: TextOverflow.ellipsis,),
        forceMaterialTransparency: true,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        actions: [
          Obx(() {
            controller.selectedLayout.value;
            return TextButton(onPressed: () async {
              if(controller.selectedLayout.value == null){
                return;
              }

              List<PhotoFilter?> selectedFilters = controller.photoFilters
                  .where((filter) => filter.photo_layout_uid == controller.selectedLayout.value!.uid)
                  .toList();

              if(controller.mergedPhotoList.length == selectedFilters.length){
                controller.uploadAllMergedImages();
                // String? result = await controller.uploadMergedImages();
                // Logger().d("result ::: ${result}");
              }else {
                Fluttertoast.showToast(msg: "모든 컷을 채워주세요.");
              }
            }, child: const Text("완료",style: TextStyle(color: Colors.white),));
          },)

        ],
      ),





      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [

            Obx(() {
              var selectedLayout = controller.selectedLayout.value;

              if(selectedLayout != null) {

                List<PhotoFilter?> selectedFilters = controller.photoFilters
                    .where((filter) => filter.photo_layout_uid == selectedLayout.uid)
                    .map((filter) => filter)
                    .toList();

                return Expanded(
                    child: Center(
                      child: Container(
                        color: Colors.white,
                        child: AspectRatio(
                          aspectRatio: selectedLayout.width / selectedLayout.height,
                          child: LayoutBuilder(builder: (context, constraints) {

                            double scaleX = constraints.maxWidth / selectedLayout.width;
                            double scaleY = constraints.maxHeight / selectedLayout.height;

                            return Stack(
                              alignment: Alignment.center,
                              children: [

                                CachedNetworkImage(imageUrl: Uri.encodeFull(
                                    "${AppSecret.s3url}${selectedLayout.original_image_filepath}"),fit: BoxFit.contain,),


                                ...selectedFilters.asMap().entries.map((e) {

                                  int index = e.key;
                                  PhotoFilter? filter = e.value;

                                  if(filter == null){
                                    return const SizedBox();
                                  }

                                  Logger().d("filter ::: ${filter?.uid}");

                                  return Positioned(
                                    left: filter.x.toDouble() * scaleX,
                                    top: filter.y.toDouble() * scaleY,
                                    width: filter.width.toDouble() * scaleX,
                                    height: filter.height.toDouble() * scaleY,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        // TODO take a new photo || edit photo
                                        // TODO argument
                                        var result = await Get.toNamed(AppRouter.camera, arguments: filter);
                                        if (result != null) {
                                          var mergedFile = result as File;
                                          controller.mergedPhotoList[index] = mergedFile;
                                        }
                                      },
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [

                                          Image.asset(
                                            "assets/image/transparent_background_small.png",
                                            fit: BoxFit.fill,
                                          ),


                                          // merged image
                                          Obx(() {
                                            if(controller.mergedPhotoList[index] != null){
                                              return Image.file(controller.mergedPhotoList[index]!);
                                            }else {
                                              return SizedBox();
                                            }
                                          },),


                                          Obx(() {
                                            if(controller.mergedPhotoList[index] == null){
                                              return CachedNetworkImage(imageUrl: Uri.encodeFull(
                                                  "${AppSecret.s3url}${filter
                                                      .original_image_filepath}"),);
                                            }else {
                                              return const SizedBox();
                                            }
                                          },),


                                        ],
                                      ),
                                    ),
                                  );

                                }),






                              ],
                            );
                          },),
                        ),
                      ),
                    )
                );
              }else {
                return const SizedBox();
              }
            },),




            Container(
              color: Colors.black,
              padding: const EdgeInsets.only(top: 10,bottom: 10),
              child: SafeArea(
                top: false,
                bottom: true,
                child: Column(
                  children: [
                    const Text("프레임 안 각각의 영역을 터치해 촬영하거나 수정할 수 있습니다", style: TextStyle(color: Colors.white, fontSize: 10),),
                    const SizedBox(height: 5,),
                    Obx(() {

                      Logger().d("selected Layout ::: ${controller.selectedLayout.value}");

                      return SizedBox(
                        height: deviceHeight * 0.12,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.photoLayouts.length,
                          itemBuilder: (context, index) => Obx((){
                            return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if(controller.mergedPhotoList.isNotEmpty){
                                    Get.dialog(
                                        CommonDialog(textContent: "이미 촬영된 사진은 저장되지 않습니다.",onClick: () {
                                          controller.mergedPhotoList.clear();
                                          controller.selectedLayout.value = controller.photoLayouts[index];
                                        },)
                                    );
                                    return;
                                  }
                                  controller.selectedLayout.value = controller.photoLayouts[index];
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10,right: 10),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.photoLayouts[index].thumbnail_image_filepath}"), fit: BoxFit.contain),
                                      if(controller.selectedLayout.value?.uid == controller.photoLayouts[index].uid)
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Transform.translate(
                                          child: Icon(Icons.check_circle,color: AppColors.main700,),
                                          offset: Offset(-5, -10),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            );
                          }),
                        ),
                      );
                    },),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );

  }
}
