import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seeya/core/config/app_colors.dart';
import 'package:seeya/core/config/app_themes.dart';
import 'package:seeya/core/services/services.dart';
import 'package:seeya/view/common/login_component.dart';
import 'package:seeya/view/common/seeya_cached_image.dart';

import '../../controller/controllers.dart';
import '../../core/config/app_router.dart';
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
                            if(UserService.instance.userDetail.value?.profileUrl != null){
                              return SeeyaCachedImage(
                                imageUrl: Uri.encodeFull("${UserService.instance.userDetail.value!.profileUrl!}"),
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
                          Obx(() {
                            var userInfo = UserService.instance.userDetail.value;
                            if(userInfo?.name == null || userInfo == null){
                              return Text("my_page.no_name_user".trParams({'user_id': (userInfo?.userId ?? 0).toString()}), style: AppThemes.headline03.copyWith(color: AppColors.blueGrey000),);
                            } else {
                              return Text("my_page.seeya_user".trParams({'name':userInfo.name!}), style: AppThemes.headline03.copyWith(color: AppColors.blueGrey000),);
                            }
                          },),
                          Obx(() => Text("my_page.login_from".trParams({'platform': UserService.instance.userDetail.value?.socialType?.value ?? ""}), style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),),
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
                  MyPageMenuButton(title: "my_page.seeya_guide_menu".tr, onTap : () async {
                    Get.toNamed(AppRouter.seeya_guide);
                  },),
                  Obx(() {
                    if(!UserService.instance.isLoginUser.value) return const SizedBox();
                    return MyPageMenuButton(title: "my_page.print_history".tr, onTap : () async {
                      Get.toNamed(AppRouter.print_history);
                    },);
                  },),
                  MyPageMenuButton(title: "my_page.qna_menu".tr, onTap : () async {
                    Get.toNamed(AppRouter.qna);
                  }),
                  Obx(() {
                    if(!UserService.instance.isLoginUser.value) return const SizedBox();
                    return MyPageMenuButton(title: "my_page.setting".tr, onTap : () async {
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
                          child: Text("my_page.logout".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),),
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


