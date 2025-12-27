import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seeya/core/config/app_colors.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/core/config/app_secret.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/seeya_cached_image.dart';
import 'package:seeya/view/dialog/home_detail_dialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final rootController = Get.find<RootController>();

    return Scaffold(
      backgroundColor: AppColors.blueGrey800,
      appBar: AppBar(
        backgroundColor: AppColors.blueGrey800,
        leadingWidth: 108,
        leading: Row(
          children: [
            const SizedBox(width: 24,),
            GestureDetector(
              onTap: () {
                if(kDebugMode){
                  Get.toNamed(AppRouter.test);
                }
              },
              child: Image.asset("assets/image/seeya_logo_small.png", width: 84, height: 36,)
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              rootController.onSearchClick();
            },
            child: SvgPicture.asset("assets/image/ic_search.svg")
          ),
          // GestureDetector(
          //   onTap: () {
          //     Get.toNamed(AppRouter.qr_scan);
          //   },
          //   child: SvgPicture.asset("assets/image/ic_qr_code.svg")
          // ),
          const SizedBox(width: 8,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {

              if(!controller.isInitialized.value) return const SizedBox();

              return PageView.builder(
                controller: controller.pageController,
                itemCount: controller.homeList.length,
                itemBuilder: (context, index) {

                  return AnimatedBuilder(
                    animation: controller.pageController,
                    builder: (context, child) {

                      double scaleValue = 1.0;

                      if (controller.pageController.position.haveDimensions) {
                        scaleValue = controller.pageController.page! - index;
                        scaleValue = (1 - (scaleValue.abs() * 0.2)).clamp(0.8, 1.0);
                      }

                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          showDialog(context: context, builder: (context) {
                            var selectedItem = controller.homeList[index];
                            return HomeDetailDialog(selectedItem: selectedItem,);
                          },);
                        },
                        child: Transform.scale(
                          scale: scaleValue,
                          child: SeeyaCachedImage(
                            imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.homeList[index].flippedImageFilepath}"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  );

                },
              );
            },),
          ),
          const SizedBox(height: 32,),
          Obx(() {
            if(controller.homeList.isEmpty) return const SizedBox();

            return SmoothPageIndicator(
              controller: controller.pageController,  // PageController
              count:  controller.homeList.length,
              axisDirection: Axis.horizontal,
              effect: const ExpandingDotsEffect(
                  spacing:  8,
                  radius:  0,
                  expansionFactor: 4,
                  dotWidth:  8,
                  dotHeight:  8,
                  paintStyle:  PaintingStyle.fill,
                  strokeWidth:  0,
                  dotColor:  AppColors.blueGrey600,
                  activeDotColor:  AppColors.primary400
              ),
            );
          },),
          const SizedBox(height: 55,),
        ],
      ),
    );

  }

}
