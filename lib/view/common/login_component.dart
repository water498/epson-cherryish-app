import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/data/repository/login_repository.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_themes.dart';
import '../../data/enum/enums.dart';
import '../../data/provider/providers.dart';
import 'sns_login_button.dart';

class LoginComponent extends GetView<LoginComponentController> {

  const LoginComponent({super.key});

  @override
  Widget build(BuildContext context) {

    // 이전에 붙어있던 controller 삭제 => 새로운 onLoginSuccess로 초기화하기 위함
    if (Get.isRegistered<LoginComponentController>()) {
      Get.delete<LoginComponentController>();
    }

    final authApi = Get.put(AuthApi());
    final loginRepository = Get.put(LoginRepository(authApi: authApi));
    final controller = Get.put(LoginComponentController(loginRepository: loginRepository));



    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("login.title".tr, style: AppThemes.headline03.copyWith(color: AppColors.blueGrey000),),

            const SizedBox(height: 40,),

            SnsLoginButton(onTap: () async {
              controller.signInWithKakao();
            }, socialType: LoginPlatform.kakao),

            const SizedBox(height: 8,),

            SnsLoginButton(onTap: () async {
              controller.signInWithNaver();
            }, socialType: LoginPlatform.naver),

            const SizedBox(height: 8,),

            SnsLoginButton(onTap: () async {
              controller.signInWithGoogle();
            }, socialType: LoginPlatform.google),

            const SizedBox(height: 8,),

            if(Platform.isIOS)
            SnsLoginButton(onTap: () async {
              controller.signInWithApple();
            }, socialType: LoginPlatform.apple),
          ],
        )
    );
  }

}
