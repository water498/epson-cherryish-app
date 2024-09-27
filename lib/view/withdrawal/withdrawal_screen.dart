import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:seeya/constants/app_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_prefs_keys.dart';
import '../../constants/app_themes.dart';
import '../../data/enum/enums.dart';
import '../../service/services.dart';
import '../common/loading_overlay.dart';

class WithdrawalScreen extends GetView<WithdrawalController> {
  const WithdrawalScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(WithdrawalController());

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
        title: Text("회원 탈퇴", style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      const Divider(height: 2, color: AppColors.blueGrey300),
                      const SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text("회원 탈퇴 주의사항", style: AppThemes.headline04.copyWith(color: AppColors.blueGrey100),),
                      ),
                      const SizedBox(height: 20,),
                      const Divider(height: 1, color: AppColors.blueGrey800),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 25, height : 25,child: Icon(Icons.circle, size: 5,color: AppColors.blueGrey300,)),
                            Expanded(child: Text("진행중 혹은 예약 완료된 이벤트가 있을 경우, 탈퇴가 가능하지 않습니다.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 25, height : 25,child: Icon(Icons.circle, size: 5,color: AppColors.blueGrey300,)),
                            Expanded(child: Text("구매 내역, 프린트 히스토리, 문의 내역 등 서비스 이용 관련 데이터가 영구 삭제 되고, 복구가 불가합니다.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 25, height : 25,child: Icon(Icons.circle, size: 5,color: AppColors.blueGrey300,)),
                            Expanded(child: Text("삭제된 데이터는 재가입 시에도 연동이 불가합니다.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 25, height : 25,child: Icon(Icons.circle, size: 5,color: AppColors.blueGrey300,)),
                            Expanded(child: Text("완료되지 않은 환불 요청건은  집행이 불가합니다.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)),
                          ],
                        ),
                      ),
                      const Divider(height: 2, color: AppColors.blueGrey700),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          controller.isAgree.value = !controller.isAgree.value;
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.blueGrey100,
                                  width: 2
                                ),
                              ),
                              child: controller.isAgree.value ? SvgPicture.asset("assets/image/ic_check_small.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey100, BlendMode.srcIn),) : const SizedBox(width: 24, height: 24,),
                            ),
                            Text("위의 내용을 모두 확인하였습니다.", style: AppThemes.headline05.copyWith(color: AppColors.blueGrey100),),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if(!controller.isAgree.value) return;

                          // TODO delete firebase auth
                          controller.signOut();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20 ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: !controller.isAgree.value ? AppColors.blueGrey700 : AppColors.primary500,
                              border: Border.all(
                                  width: 2,
                                  color: !controller.isAgree.value ? AppColors.blueGrey600 : AppColors.primary400.withOpacity(0.8)
                              )
                          ),
                          child: Text("탈퇴하기", style: AppThemes.headline05.copyWith(color: !controller.isAgree.value ? AppColors.blueGrey500 : Colors.white),textAlign: TextAlign.center,),
                        ),
                      ),
                    ],
                  );
                },)
            )
            
          ],
        ),
      ),
    );
  }

}

class WithdrawalController extends GetxController{

  var isAgree = false.obs;

  void signOut() async {

    LoadingOverlay.show(null);
    await Future.delayed(const Duration(milliseconds: 500));
    LoadingOverlay.hide();

    String? loginPlatform = AppPreferences().prefs?.getString(AppPrefsKeys.loginPlatform);

    if(loginPlatform != null){
      switch (loginPlatform) {
        case 'google':
          await GoogleSignIn().signOut();
          break;
        case 'kakao':
          await UserApi.instance.logout();
          break;
        case 'naver':
          await FlutterNaverLogin.logOut();
          break;
        case 'apple':
        case 'none':
          break;
      }
    }

    await FirebaseAuth.instance.signOut();
    await AppPreferences().prefs?.remove(AppPrefsKeys.userAccessToken); // remove access token
    await AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.none.toDisplayString());
    UserService.instance.userInfo.value = null;


    Get.offAllNamed(AppRouter.custom_splash);

  }

}
