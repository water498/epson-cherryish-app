import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/data/enum/enums.dart';
import 'package:seeya/service/services.dart';
import 'package:seeya/view/common/vertical_slider.dart';
import 'package:seeya/view/dialog/common_dialog.dart';
import 'package:seeya/view/common/sns_login_button.dart';
import 'package:seeya/view/common/login_component.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_router.dart';
import '../../controller/controllers.dart';
import '../../utils/package_info_utils.dart';
import 'my_page_menu_button.dart';

class MyPageScreen extends GetView<MyPageController> {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final deviceHeight = MediaQuery.of(context).size.height;
    final homeController = Get.find<HomeController>();
    final rootController = Get.find<RootController>();


    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              rootController.onSearchClick();
            },
            child: SvgPicture.asset("assets/image/ic_search.svg")
          ),
          // GestureDetector(
          //   onTap: () {
          //     Get.toNamed(AppRouter.qr_scan);
          //   },
          //   child: SvgPicture.asset("assets/image/ic_qr_code.svg")
          // ),
          const SizedBox(width: 8,),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [

            Obx(() {
              if(UserService.instance.isLoginUser.value){
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  margin: const EdgeInsets.only(top: 52),
                  child: Row(
                    children: [
                      Container(
                        color: AppColors.blueGrey700 ,
                        child: SizedBox(
                          width: 73,
                          height: 73,
                          child: Obx(() {
                            if(UserService.instance.userPublicInfo.value?.profile_url != null){
                              return CachedNetworkImage(
                                imageUrl: Uri.encodeFull("${UserService.instance.userPublicInfo.value!.profile_url!}"),
                                fit: BoxFit.cover,
                              );
                            }else {
                              return SvgPicture.asset("assets/image/ic_default_profile.svg");
                            }
                          },)
                        ),
                      ),
                      const SizedBox(width: 12,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text("[${UserService.instance.userPublicInfo.value?.name ?? "시야 손님 ${UserService.instance.userPublicInfo.value?.id ?? ""}"}]", style: AppThemes.headline03.copyWith(color: AppColors.blueGrey000),),),
                          Obx(() => Text("${UserService.instance.userPublicInfo.value?.social_type}로 로그인", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: const LoginComponent(),
                );
              }
            },),






            const SizedBox(height: 28,),


            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Divider(height: 2, color: AppColors.blueGrey300),
                  MyPageMenuButton(title: "Seeya 안내", onTap : () async {
                    Get.toNamed(AppRouter.seeya_guide);
                  },),
                  Obx(() {
                    if(!UserService.instance.isLoginUser.value) return const SizedBox();
                    return MyPageMenuButton(title: "프린트 히스토리", onTap : () async {
                      Get.toNamed(AppRouter.print_history);
                    },);
                  },),
                  Obx(() {
                    if(!UserService.instance.isLoginUser.value) return const SizedBox();
                    return MyPageMenuButton(title: "에러 리포트", onTap : () async {
                      Get.toNamed(AppRouter.report);
                    },);
                  },),
                  MyPageMenuButton(title: "자주 묻는 질문", onTap : () async {
                    Get.toNamed(AppRouter.qna);
                  }),
                  Obx(() {
                    if(!UserService.instance.isLoginUser.value) return const SizedBox();
                    return MyPageMenuButton(title: "설정", onTap : () async {
                      Get.toNamed(AppRouter.setting);
                    },showDivider: false,);
                  },),
                  const Divider(height: 2, color: AppColors.blueGrey700,),
                  const SizedBox(height: 20,),
                  Obx(() {
                    if(!UserService.instance.isLoginUser.value) return const SizedBox();
                    return GestureDetector(
                        onTap: () {
                          controller.signOut();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Text("로그아웃", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),),
                        )
                    );
                  },),

                  const SizedBox(height: 20,),

                ],
              ),
            ),





          ],
        ),
      ),
    );
  }

}


