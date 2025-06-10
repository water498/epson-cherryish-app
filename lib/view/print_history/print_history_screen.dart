import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/app_themes.dart';

class PrintHistoryScreen extends GetView<PrintHistoryController> {
  const PrintHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

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
        title: Text("print_history.title".tr, style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
      ),
      body: Obx(() {
        if(!controller.isLoadFinish.value) return const SizedBox();

        if(controller.historyList.isEmpty){
          return Center(
            child: Text("print_history.empty".tr)
          );
        }else {
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.historyList.length,
                  itemBuilder: (context, index) {

                    var history = controller.historyList[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                              AppRouter.image_viewer,
                              arguments: {
                                "image_path" : Uri.encodeFull("${AppSecret.s3url}${history.print_filepath}"),
                                "hero_tag" : "print_history_viewer$index",
                              }
                          );
                        },
                        child: Hero(
                          tag: "print_history_viewer$index",
                          child: CachedNetworkImage(
                            imageUrl: Uri.encodeFull("${AppSecret.s3url}${history.print_filepath}"),
                            placeholder: (context, url) => Image.asset("assets/image/loading02.gif"),
                          ),
                        ),
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
