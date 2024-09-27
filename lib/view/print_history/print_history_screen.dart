import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/app_themes.dart';

class PrintHistoryScreen extends GetView<PrintHistoryController> {
  const PrintHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(PrintHistoryController());

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
        title: Text("프린트 히스토리", style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
      ),
      body: Obx(() {
        if(!controller.isLoadFinish.value) return const SizedBox();

        if(controller.historyList.isEmpty){
          return Center(
            child: Text("히스토리가 존재하지 않습니다.")
          );
        }else {
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.historyList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: Uri.encodeFull("https://img.wkorea.com/w/2022/12/style_638816e9c23d8.jpg")
                      ),
                    );
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: controller.pageController,
                count:  controller.historyList.length,
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
              ),
              const SizedBox(height: 130,),
            ],
          );
        }
      },),
    );
  }

}
