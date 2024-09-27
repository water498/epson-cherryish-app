import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/bouncing_button.dart';

import '../../../constants/app_themes.dart';

class ErrorReportScreen extends GetView<ErrorReportController> {
  const ErrorReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ErrorReportController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text("에러 리포트", style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset("assets/image/ic_close.svg",)
          ),
          const SizedBox(width: 16,),
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 24, right: 6, bottom: 20 ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 2,
                            color: AppColors.blueGrey600
                        )
                    ),
                    child: Text("취소", style: AppThemes.headline05.copyWith(color: AppColors.blueGrey200),textAlign: TextAlign.center,),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if(controller.selectedImage.value == null) return;

                    await controller.uploadImage();
                  },
                  child: Obx(() {
                    return Container(
                      margin: const EdgeInsets.only(left: 6, right: 24, bottom: 20 ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: controller.selectedImage.value == null ? AppColors.blueGrey700 : AppColors.primary500,
                          border: Border.all(
                              width: 2,
                              color: controller.selectedImage.value == null ? AppColors.blueGrey600 : AppColors.primary400.withOpacity(0.8)
                          )
                      ),
                      child: Text("등록", style: AppThemes.headline05.copyWith(color: controller.selectedImage.value == null ? AppColors.blueGrey500 : Colors.white),textAlign: TextAlign.center,),
                    );
                  },),
                ),
              ),
            ],
          )
      ),
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("에러가 발생한 상황이나\n프레임의 사진을 첨부해주세요.", style: AppThemes.headline05.copyWith(color: AppColors.blueGrey200),textAlign: TextAlign.start,),
                const SizedBox(height: 20,),
                Obx(() {
                  if(controller.selectedImage.value == null){
                    return BouncingButton(
                      onTap: () async {
                        await controller.pickImage();
                      },
                      child: DottedBorder(
                        borderType: BorderType.Rect,
                        color: AppColors.blueGrey600,
                        dashPattern: const [4,4],
                        strokeWidth: 2,
                        child: Container(
                          color: AppColors.blueGrey800,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/image/ic_image.svg"),
                                Text("사진 첨부하기",style: AppThemes.headline04.copyWith(color: AppColors.blueGrey200),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Stack(
                      children: [
                        Image.file(controller.selectedImage.value!, fit: BoxFit.fitWidth,),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedImage.value = null;
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(width: 24, height: 24, color: AppColors.blueGrey000,),
                                SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                },),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
