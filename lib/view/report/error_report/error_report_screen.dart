import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/core/config/app_colors.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/bouncing_button.dart';
import 'package:seeya/view/common/common_widget.dart';

import '../../../core/config/app_themes.dart';

class ErrorReportScreen extends GetView<ErrorReportController> {
  const ErrorReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text("error_report.title".tr, style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
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
                    child: Text("error_report.cancel".tr, style: AppThemes.headline05.copyWith(color: AppColors.blueGrey200),textAlign: TextAlign.center,),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if(controller.selectedImage.value == null) return;

                    await controller.uploadImage(onSuccess: (filepath) async {
                      await controller.reportError(
                        reportFilepath: filepath,
                        onSuccess: () {
                          controller.showSuccessDialog(context);
                        },
                      );
                    },);
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
                      child: Text("error_report.register".tr, style: AppThemes.headline05.copyWith(color: controller.selectedImage.value == null ? AppColors.blueGrey500 : Colors.white),textAlign: TextAlign.center,),
                    );
                  },),
                ),
              ),
            ],
          )
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("error_report.error_reason_title".tr, style: AppThemes.headline05.copyWith(color: AppColors.blueGrey200),textAlign: TextAlign.start,),
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
                                  Text("error_report.upload_photo".tr,style: AppThemes.headline04.copyWith(color: AppColors.blueGrey200),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Image.file(controller.selectedImage.value!, fit: BoxFit.contain, height: 200,),
                            GestureDetector(
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
                            )
                          ],
                        ),
                      );
                    }
                  },),

                  // addH(30),
                  //
                  // Container(
                  //   child: TextField(
                  //     focusNode: controller.focusNode,
                  //     controller: controller.textController,
                  //     maxLength: 300,
                  //     maxLines: 8,
                  //     decoration: const InputDecoration(
                  //       enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide.none
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide.none
                  //       ),
                  //       contentPadding: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
                  //       hintText: "에러 사유를 적어주세요.",
                  //     ),
                  //     cursorColor: AppColors.primary400,
                  //     cursorWidth: 5,
                  //     style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100),
                  //   ),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //       color: Colors.black,
                  //       width: 1,
                  //     )
                  //   ),
                  // ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
