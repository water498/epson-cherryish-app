import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/constants/seeya_frame_configs.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/utils/file_utils.dart';
import 'package:seeya/utils/image_utils.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../dialog/dialogs.dart';


class DecorateFrameScreen extends GetView<DecorateFrameController> {
  const DecorateFrameScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    const frameWidth = SeeyaFrameConfigs.frameWidth;
    const frameHeight = SeeyaFrameConfigs.frameHeight;
    const filterWidth = SeeyaFrameConfigs.filterWidth;
    const filterHeight = SeeyaFrameConfigs.filterHeight;

    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide > 600;
    
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          handleBackPress(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.blueGrey100,
        appBar: AppBar(
          backgroundColor: AppColors.blueGrey100,
          leadingWidth: 64,
          leading: Row(
            children: [
              const SizedBox(width: 16,),
              GestureDetector(
                onTap: () {
                  handleBackPress(context);
                },
                child: SvgPicture.asset("assets/image/ic_back.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
              ),
            ],
          ),
          title: Text("프레임 내부 꾸미기", style: AppThemes.headline04.copyWith(height: 0),),
          centerTitle: true,
        ),

        bottomNavigationBar: SafeArea(
            child: GestureDetector(
              onTap: () async {

                controller.printFinalFrame(context);

              },
              child: Obx(() {
                bool allPhotosCaptured = controller.mergedPhotoList.values.where((value) => value != null).length == controller.eventFilterList.length;

                return Container(
                  margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20 ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: allPhotosCaptured ? AppColors.primary500 : AppColors.blueGrey700,
                      border: Border.all(
                          width: 2,
                          color: allPhotosCaptured ? AppColors.primary400.withOpacity(0.8) : AppColors.blueGrey600,
                      )
                  ),
                  child: Text("프린트 하기", style: AppThemes.headline05.copyWith(color: allPhotosCaptured ? Colors.white : AppColors.blueGrey500),textAlign: TextAlign.center,),
                );
              },),
            )
        ),

        body: Column(
          children: [
            const SizedBox(height: 30,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                        child: AspectRatio(
                          aspectRatio: frameWidth / frameHeight,
                          child: LayoutBuilder(
                            builder: (context, constraints) {

                              var frame = controller.eventFrame;

                              double scaleX = constraints.maxWidth / frameWidth;
                              double scaleY = constraints.maxHeight / frameHeight;

                              return Stack(
                                alignment: Alignment.center,
                                children: [

                                  ...controller.eventFilterList.asMap().entries.map((e) {

                                    int index = e.key;
                                    EventFilterModel filter = e.value;

                                    final Point filterPoint = SeeyaFrameConfigs.getFilterXY(frame.frame_type, filter.type);

                                    return Positioned(
                                      left: filterPoint.x * scaleX,
                                      top: filterPoint.y * scaleY,
                                      width: filterWidth * scaleX,
                                      height: filterHeight * scaleY,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () async {
                                            var result = await Get.toNamed(
                                                AppRouter.camera,
                                                arguments: {
                                                  "selected_index" : index,
                                                });
                                          },
                                        child: Stack(
                                          children: [

                                            // background
                                            Container(
                                              color: AppColors.blueGrey800,
                                            ),

                                            // merged image
                                            Obx(() {
                                              if(controller.mergedPhotoList[index] != null){
                                                return Image.file(
                                                  controller.mergedPhotoList[index]!.file,
                                                  fit: BoxFit.fill,
                                                );
                                              }else {
                                                return const SizedBox();
                                              }
                                            },),

                                            // filter
                                            Obx(() {
                                              if(controller.mergedPhotoList[index] == null && filter.image_filepath != null){
                                                return CachedNetworkImage(
                                                  imageUrl: Uri.encodeFull("${AppSecret.s3url}${filter.image_filepath}"),
                                                  fit: BoxFit.fill,
                                                );
                                              }else {
                                                return const SizedBox();
                                              }
                                            },),

                                            // add icon
                                            Obx(() {
                                              if(controller.mergedPhotoList[index] == null){
                                                return Center(child: SvgPicture.asset("assets/image/ic_add.svg", width: isTablet ? 80 : null,));
                                              }else {
                                                return const SizedBox();
                                              }
                                            },),

                                          ],
                                        ),
                                      ),
                                    );

                                  }),



                                  // original frame
                                  IgnorePointer(
                                    child: CachedNetworkImage(
                                      imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.eventFrame.original_image_filepath}"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),


                                ],
                              );
                            },
                          )
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(controller.eventFrame.name, style: AppThemes.bodyMedium.copyWith(color: Colors.white),textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }



  void handleBackPress(BuildContext context){
    if(controller.mergedPhotoList.isNotEmpty){
      showDialog(context: context, builder: (context) {
        return CommonDialog(
          needWarning: true,
          title: "프레임을 삭제하시겠어요?",
          description: "지금 돌아가면 변경 사항이 삭제됩니다.",
          button01text: "삭제하기",
          onButton01Click: () async {
            controller.mergedPhotoList.forEach((key, value) async {
              if(value != null){
                await FileUtils.deleteFile(value.file.path);
              }
            },);
            Get.back();
          },
          button02text: "계속 제작하기",
          onButton02Click: () {},
        );
      },);
    }else {
      Get.back();
    }
  }


}
