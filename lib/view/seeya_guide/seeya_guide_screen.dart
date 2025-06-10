import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/seeya_guide/seeya_guide_item.dart';

class SeeyaGuideScreen extends GetView<SeeyaGuideController> {
  const SeeyaGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(SeeyaGuideController());

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: Row(
          children: [
            const SizedBox(width: 16,),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset("assets/image/ic_back.svg"),
            ),
          ],
        ),
        centerTitle: false,
        title: Text("seeya_guide.title".tr, style: AppThemes.headline04.copyWith(color: Colors.black,height: 0),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            Scrollbar(
              controller: controller.scrollController,
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text("seeya_guide.description".tr, style: AppThemes.headline04.copyWith(color: Colors.black),),
                      SeeyaGuideItem(step: "step 1", title: "seeya_guide.step1_title".tr, description: "seeya_guide.step1_description".tr, imgUrl: "assets/image/seeya_guide01.png",),
                      SeeyaGuideItem(step: "step 2", title: "seeya_guide.step2_title".tr, description: "seeya_guide.step2_description".tr, imgUrl: "assets/image/seeya_guide02.png",),
                      SeeyaGuideItem(step: "step 3", title: "seeya_guide.step3_title".tr, description: "seeya_guide.step3_description".tr, imgUrl: "assets/image/seeya_guide03.png",),
                      const SizedBox(height: 100,),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Obx(() {
                if(controller.showFAB.value){
                  return GestureDetector(
                    onTap: () {
                      controller.scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: SafeArea(
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                            color: AppColors.primary400,
                            shape: BoxShape.circle
                        ),
                        child: Transform.rotate(
                          angle: pi / 2,
                          child: SvgPicture.asset("assets/image/ic_back.svg",colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),)
                        ),
                      ),
                    ),
                  );
                }else {
                  return const SizedBox();
                }
              }),
            ),

          ],
        ),
      ),
    );
  }

}
