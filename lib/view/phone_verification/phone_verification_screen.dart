
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/core/utils/utils.dart';
import 'package:seeya/view/common/common_widget.dart';

import '../../core/config/app_colors.dart';
import '../../core/config/app_themes.dart';

class PhoneVerificationScreen extends GetView<PhoneVerificationController> {
  const PhoneVerificationScreen({super.key});

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
        ),

        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(
              child: GestureDetector(
                onTap: () async {

                  controller.onButtonClick(context);

                },
                child: Obx(() {
                  bool isPhoneEmpty = controller.isPhoneEmpty.value;

                  return Container(
                    margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20 ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: isPhoneEmpty ? AppColors.blueGrey700 : AppColors.primary500,
                        border: Border.all(
                          width: 2,
                          color: isPhoneEmpty ? AppColors.blueGrey600 : AppColors.primary400.withOpacity(0.8),
                        )
                    ),
                    child: Obx(() => Text(controller.showVerifyCodeWidget.value ? "phone_verification.bottom_button_next".tr :"phone_verification.bottom_button_get_code".tr, style: AppThemes.headline05.copyWith(color: isPhoneEmpty ? AppColors.blueGrey500 : Colors.white),textAlign: TextAlign.center,),),
                  );
                },),
              )
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("phone_verification.title".tr, style: AppThemes.headline03.copyWith(color: AppColors.blueGrey000),),
                addH(8),
                Text("phone_verification.sub_title".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),),
                addH(40),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("phone_verification.phone".tr, style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),
                      addH(4),
                      Obx(() {
                        return TextField(

                          maxLength: 15,
                          autofocus: true,
                          canRequestFocus: controller.disableTextField.value ? false : true,
                          readOnly: controller.disableTextField.value ? true : false,
                          focusNode: controller.phoneFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.next,
                          onSubmitted: (value) {

                          },
                          controller: controller.phoneTextController,
                          decoration: InputDecoration(
                            counterText:'',
                            hintText: "phone_verification.phone_hint".tr,
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.zero),
                                borderSide: BorderSide(
                                  color: AppColors.blueGrey600,
                                  width: 2,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.zero),
                                borderSide: BorderSide(
                                  color: AppColors.blueGrey100,
                                  width: 2,
                                )
                            ),
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CountryCodePicker(
                                  showFlagMain: false,
                                  hideHeaderText: true,
                                  hideSearch: false,
                                  flagWidth: 25,
                                  padding: const EdgeInsets.only(left: 5),
                                  onChanged: (value) {
                                    if(value.code != null){
                                      controller.isoCode = value.code!;
                                    }
                                  },
                                  initialSelection: 'KR', // 기본 선택 국가
                                  // favorite: ['+82', 'KR'], // 즐겨찾기 항목
                                  // countryFilter: ['KR', 'US', 'JP'], // ✨ 여기서 필터링!
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                ),
                                SvgPicture.asset("assets/image/ic_arrow_down.svg",width: 15,),
                                const SizedBox(width: 10,),
                              ],
                            )
                          ),
                        );
                      },),
                    ],
                  ),
                ),
                addH(24),
                Obx(() {
                  return IgnorePointer(
                    ignoring: !controller.showVerifyCodeWidget.value,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: controller.showVerifyCodeWidget.value ? 1.0 : 0.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("phone_verification.code".tr, style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),
                          addH(4),
                          TextField(
                            maxLength: 6,
                            focusNode: controller.codeFocusNode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textInputAction: TextInputAction.next,
                            onSubmitted: (value) {

                            },
                            controller: controller.codeTextController,
                            decoration: InputDecoration(
                              counterText:'',
                              hintText: "phone_verification.code_hint".tr,
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                    color: AppColors.blueGrey600,
                                    width: 2,
                                  )
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                    color: AppColors.blueGrey100,
                                    width: 2,
                                  )
                              ),
                              suffixIcon: Obx(() {
                                if(!controller.isTimeExpired.value){
                                  if(controller.timer != null){
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(FormatUtils.formatSecondsToMMSS(controller.timeRemaining.value),style: AppThemes.bodyMedium.copyWith(color: AppColors.error),textAlign: TextAlign.center,),
                                      ],
                                    );
                                  }else {
                                    return const SizedBox();
                                  }
                                }else {
                                  return const SizedBox();
                                }
                              },)
                            ),
                          ),
                          addH(4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                controller.reset(false);
                              },
                              child: Text("phone_verification.code_resend".tr,style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300, decoration: TextDecoration.underline), )
                            )
                          )
                        ],
                      ),
                    ),
                  );
                },),

              ],
            ),
          ),
        ),
      );
  }

}


