import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/utils/format_utils.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_themes.dart';

class EnterUserInfoScreen extends GetView<EnterUserInfoController> {
  const EnterUserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(EnterUserInfoController());

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
              child: Obx(() {
                return GestureDetector(
                  onTap: () async {

                    if(controller.canPass.value){
                      Get.toNamed(AppRouter.sign_up_finish);
                    }

                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20 ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: !controller.canPass.value ? AppColors.blueGrey700 : AppColors.primary500,
                        border: Border.all(
                            width: 2,
                            color: !controller.canPass.value ? AppColors.blueGrey600 : AppColors.primary400.withOpacity(0.8)
                        )
                    ),
                    child: Text("완료", style: AppThemes.headline05.copyWith(color: !controller.canPass.value ? AppColors.blueGrey500 : Colors.white),textAlign: TextAlign.center,),
                  ),
                );
              },)
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("필수 정보 입력", style: AppThemes.headline03.copyWith(color: AppColors.blueGrey000),),
                const SizedBox(height: 40,),
                Text("이름", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),
                const SizedBox(height: 4,),
                TextField(
                  maxLength: 10,
                  focusNode: controller.nameFocusNode,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(controller.emailFocusNode);
                  },
                  controller: controller.nameTextController,
                  decoration: const InputDecoration(
                    counterText:'',
                    hintText: "이름 입력",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: AppColors.blueGrey600,
                        width: 2,
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                        borderSide: BorderSide(
                          color: AppColors.blueGrey100,
                          width: 2,
                        )
                    )
                  ),
                ),
                const SizedBox(height: 24,),
                Text("이메일", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),
                const SizedBox(height: 4,),
                Obx(() {

                  // check duplicate
                  var fail = controller.showDuplicateView.value;
                  var success = controller.showEmailCheckedView.value;

                  return TextField(
                    maxLength: 30,
                    focusNode: controller.emailFocusNode,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailTextController,
                    style: AppThemes.bodyMedium.copyWith(fontFamily: "Inter"),
                    decoration: InputDecoration(
                        counterText:'',
                        hintText: "이메일 주소",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.zero),
                            borderSide: BorderSide(
                              color: fail ? AppColors.error : success ? AppColors.blueGrey800 : AppColors.blueGrey600,
                              width: 2,
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.zero),
                            borderSide: BorderSide(
                              color: fail ? AppColors.error : AppColors.blueGrey100,
                              width: 2,
                            )
                        ),
                        suffix: GestureDetector(
                          onTap: () async {

                            if(controller.isEmailEmpty.value) return;

                            var email = controller.emailTextController.text;
                            if(!FormatUtils.isEmailValid(email)){
                              Fluttertoast.showToast(msg: "유효하지 않는 이메일 입니다.", gravity: ToastGravity.TOP);
                              return;
                            }

                            await controller.checkDuplicate();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Obx(() {
                              return Text("중복확인", style: AppThemes.bodyMedium.copyWith(color: controller.isEmailEmpty.value ? AppColors.blueGrey400 : AppColors.primary400),);
                            },),
                          ),
                        )
                    ),
                  );
                },),
                Obx(() {
                  if(!controller.showDuplicateView.value && !controller.showEmailCheckedView.value) return const SizedBox();

                  // check duplicate
                  var fail = controller.showDuplicateView.value;
                  var success = controller.showEmailCheckedView.value;

                  return Container(
                    color: fail ? AppColors.error : success ? AppColors.primary900 : Colors.white,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const SizedBox(width: 2,),
                        SvgPicture.asset(fail ? "assets/image/ic_warning_small.svg" : success ? "assets/image/ic_check_small.svg" : ""),
                        Text(
                          fail ? "이미 사용중인 이메일입니다." : success ? "사용 가능한 이메일입니다." : "",
                          style: AppThemes.bodySmall.copyWith(color: fail ? Colors.white : success ? AppColors.primary400 : Colors.white),
                        ),
                        const SizedBox(width: 8,),
                      ],
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
