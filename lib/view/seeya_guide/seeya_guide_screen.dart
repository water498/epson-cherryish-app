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
        title: Text("Seeya 안내", style: AppThemes.headline04.copyWith(color: Colors.black,height: 0),),
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
                      Text("내 손 안의 포토부스, 시야", style: AppThemes.headline04.copyWith(color: Colors.black),),
                      const SeeyaGuideItem(step: "step 1", title: "찾고", description: "특별했던 장소의 프레임을\n'시야'에서 찾아보세요!", imgUrl: "assets/image/seeya_guide01.png",),
                      const SeeyaGuideItem(step: "step 2", title: "찍고", description: "선택한 프레임에 기억하고 싶은 순간들을\n넣어보세요!", imgUrl: "assets/image/seeya_guide02.png",),
                      const SeeyaGuideItem(step: "step 3", title: "뽑고", description: "결제를 마치고 조금만 기다리면\n한장에 담기는 소중한 오늘이 당신 손안에!", imgUrl: "assets/image/seeya_guide03.png",),
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
