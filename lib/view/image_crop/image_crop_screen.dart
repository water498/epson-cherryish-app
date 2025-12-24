import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/seeya_frame_configs.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/image_crop/image_crop_overlay.dart';

import '../../constants/app_secret.dart';
import '../../constants/app_themes.dart';

class ImageCropScreen extends GetView<ImageCropController> {
  const ImageCropScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const filterWidth = SeeyaFrameConfigs.filterWidth;
    const filterHeight = SeeyaFrameConfigs.filterHeight;

    final controller = Get.put(ImageCropController());
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide > 600;

    return Scaffold(
      backgroundColor: AppColors.blueGrey000,
      appBar: AppBar(
        backgroundColor: AppColors.blueGrey000,
        automaticallyImplyLeading: false,
        title: kDebugMode ? Obx(() => Text("x ::: ${controller.x.value}\ny ::: ${controller.y.value}\nscale ::: ${controller.scale.value}\ninitialScale ::: ${controller.initialScale}"),) : null,
        actions: [
          Obx(() {
            if(controller.isCapturing.value) return const SizedBox();

            return GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),)
            );
          },),
          const SizedBox(width: 16,),
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: GestureDetector(
            onTap: () async {

              if(controller.isCapturing.value) return;
              controller.captureImage();

            },
            child: Obx(() {
              return Opacity(
                opacity: controller.isCapturing.value ? 0.0 : 1.0,
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24, bottom: 35, top: 20 ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.primary500,
                      border: Border.all(
                          width: 2,
                          color: AppColors.primary400.withOpacity(0.8)
                      )
                  ),
                  child: Text("image_crop.button".tr, style: AppThemes.headline05.copyWith(color: Colors.white),textAlign: TextAlign.center,),
                ),
              );
            },),
          )
      ),
      body: GestureDetector(
        onScaleUpdate: (details) {
          double imageX = (controller.x.value + details.focalPointDelta.dx);
          double imageY = controller.y.value + details.focalPointDelta.dy;

          final double currentScale = details.scale;

          double scaleChange = currentScale - controller.previousScale;
          controller.previousScale = currentScale;

          if(controller.scale.value == 0.0 || controller.cropRectWidth == 0.0 || controller.cropRectHeight == 0.0) return;

          if(scaleChange != 0 && details.pointerCount == 2){
            var velocity = isTablet ? 5 : 10;

            // 현재 scale 저장
            final double oldScale = controller.scale.value;

            // 새로운 scale 계산
            final double newScale = (controller.scale.value + (scaleChange/velocity)).clamp(controller.initialScale, 10.0);

            // Crop 영역의 중심점
            final double cropCenterX = controller.cropRectWidth / 2;
            final double cropCenterY = controller.cropRectHeight / 2;

            // 현재 중심점에 해당하는 이미지 상의 좌표 (scale 변경 전)
            final double imageCenterX = (cropCenterX - controller.x.value) / oldScale;
            final double imageCenterY = (cropCenterY - controller.y.value) / oldScale;

            // Scale 적용
            controller.scale.value = newScale;

            // 같은 이미지 지점이 중심에 오도록 x, y 재계산
            controller.x.value = cropCenterX - (imageCenterX * newScale);
            controller.y.value = cropCenterY - (imageCenterY * newScale);

            // 중심 기준 줌 적용 후 imageX/imageY 동기화
            imageX = controller.x.value;
            imageY = controller.y.value;
          }

          if (imageX > 0) {
            imageX = 0;
          } else if (imageX < -((controller.imageWidth * controller.scale.value - controller.cropRectWidth).abs())) {
            imageX = -((controller.imageWidth * controller.scale.value - controller.cropRectWidth).abs());
          }

          if (imageY > 0) {
            imageY = 0;
          } else if (imageY < -((controller.imageHeight * controller.scale.value - controller.cropRectHeight).abs())) {
            imageY = -((controller.imageHeight * controller.scale.value - controller.cropRectHeight).abs());
          }

          controller.x.value = imageX;
          controller.y.value = imageY;
        },
        child: ClipRect(
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Obx(() {
                if(!controller.isInitialized.value) return const SizedBox();

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.1, vertical: deviceHeight * 0.1),

                  child: Stack(
                    children: [

                      // 실제 크롭 부분
                      RepaintBoundary(
                        key: controller.boundaryKey,
                        child: AspectRatio(
                          aspectRatio: filterWidth / filterHeight,
                          child: LayoutBuilder(
                            builder: (context, constraints) {

                              controller.cropRectWidth = constraints.maxWidth;
                              controller.cropRectHeight = constraints.maxHeight;

                              var cropRectWidth = controller.cropRectWidth;
                              var cropRectHeight = controller.cropRectHeight;

                              Logger().d("crop rect width ::: $cropRectWidth height ::: $cropRectHeight");

                              if((cropRectWidth / controller.imageWidth) * controller.imageHeight < cropRectHeight){
                                controller.initialScale = cropRectHeight / controller.imageHeight;
                              }else {
                                controller.initialScale = cropRectWidth / controller.imageWidth;
                              }

                              // set initial value
                              WidgetsBinding.instance.addPostFrameCallback((_) {

                                // 초기 스케일 설정 (WidgetBinding 아니면 LayoutBuilder와 rebuild 충돌)
                                if (controller.scale.value == 0.0) {
                                  controller.scale.value = controller.initialScale;
                                }

                                // 이미지 중앙부터 시작
                                if((cropRectWidth / controller.imageWidth) * controller.imageHeight < cropRectHeight){
                                  controller.x.value = -(((controller.imageWidth * controller.initialScale - cropRectWidth) / 2).abs());
                                }else {
                                  controller.y.value = -(((controller.imageHeight * controller.scale.value - cropRectHeight) / 2).abs());
                                }
                              });

                              return Obx(() {
                                return Stack(
                                  clipBehavior: controller.isCapturing.value ? Clip.hardEdge : Clip.none,
                                  children: [

                                    // stack을 벗어나는 사용자 이미지
                                    Obx(() {
                                      return Positioned(
                                          left: controller.x.value,
                                          top: controller.y.value,
                                          width: controller.imageWidth * controller.scale.value,
                                          height: controller.imageHeight * controller.scale.value,
                                          child: Image.file(controller.selectedImage, fit: BoxFit.fill,)
                                      );
                                    },),


                                    // filter image
                                    if(controller.filter.image_filepath != null)
                                      IgnorePointer(
                                        child: CachedNetworkImage(
                                          imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.filter.image_filepath}"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),

                                  ],
                                );
                              },);
                            },
                          ),
                        ),
                      ),

                      // crop rect
                      AspectRatio(
                        aspectRatio: filterWidth / filterHeight,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return CustomPaint(
                              painter: ImageCropOverlay(rect: Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxHeight)),
                              child: const SizedBox.expand(),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                );
              },),
            ),
          ),
        ),
      ),
    );
  }

}
