import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/service/services.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_themes.dart';

class SignUpFinishScreen extends StatelessWidget {
  const SignUpFinishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: GestureDetector(
          onTap: () async {

            // TODO event 에서 왔는지 mypage에서 왔는지 판단
            Get.back();

          },
          child: Container(
            margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20 ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: AppColors.primary500,
                border: Border.all(
                    width: 2,
                    color: AppColors.primary400.withOpacity(0.8)
                )
            ),
            child: Text("시작하기", style: AppThemes.headline05.copyWith(color: Colors.white),textAlign: TextAlign.center,),
          ),
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/image/ic_check_large.svg"),
          const SizedBox(height: 32,),
          Text("회원가입이\n성공적으로 완료되었습니다!", style: AppThemes.headline03.copyWith(color: AppColors.blueGrey000), textAlign: TextAlign.center,),
          Obx(() => Text("[${UserService.instance.userInfo.value?.name ?? ""}]님, 반갑습니다!", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300), textAlign: TextAlign.center,),),
        ],
      ),
    );
  }

}
