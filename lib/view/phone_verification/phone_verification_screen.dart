import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/utils/utils.dart';
import 'package:seeya/view/common/common_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_themes.dart';

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
                    child: Obx(() => Text(controller.showVerifyCodeWidget.value ? "다음" :"인증번호 받기", style: AppThemes.headline05.copyWith(color: isPhoneEmpty ? AppColors.blueGrey500 : Colors.white),textAlign: TextAlign.center,),),
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
                Text("본인 인증", style: AppThemes.headline03.copyWith(color: AppColors.blueGrey000),),
                addH(8),
                Text("원활한 서비스 이용을 위해,\n휴대폰 번호를 입력해주세요.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),),
                addH(40),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("휴대폰 번호", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),
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
                            hintText: "-를 제외하고 입력해주세요.",
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
                            // prefixIcon: Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     TextButton(onPressed: () async {
                            //       Fluttertoast.showToast(msg: "country code ::: ${DeviceInfoUtils.getDeviceCountry()}");
                            //     }, child: Text("+82")),
                            //   ],
                            // )
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
                          Text("인증 번호", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),
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
                              hintText: "인증 번호 6자리",
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
                              child: Text("인증 번호 재전송",style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300, decoration: TextDecoration.underline), )
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


