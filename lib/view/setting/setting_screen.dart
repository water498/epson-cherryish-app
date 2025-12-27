import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/data/enum/enums.dart';
import 'package:seeya/view/common/bouncing_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_colors.dart';
import '../../core/config/app_themes.dart';
import '../../core/services/services.dart';
import '../../core/utils/utils.dart';
import '../tab_my_page/my_page_menu_button.dart';
import 'setting_sns_icon.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // 제일 긴 텍스트 가로 크기 측정
    double maxLabelWidth = 0.0;

    final textPainter = TextPainter(
      text: TextSpan(text: "setting.user_info_email".tr, style: AppThemes.bodyMedium.copyWith(fontFamily: "DungGeunMo"),),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    maxLabelWidth =  textPainter.size.width + 40; // 오른

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
        title: Text("setting.title".tr, style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 2, color: AppColors.blueGrey300),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("setting.user_info_title".tr, style: AppThemes.headline04.copyWith(color: AppColors.blueGrey100),),
                    const SizedBox(height: 20,),
                    const Divider(height: 1, color: AppColors.blueGrey800),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(
                            width: maxLabelWidth,
                            child: Text("setting.user_info_name".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)
                        ),
                        Expanded(child: Obx(() => Text("${UserService.instance.userPublicInfo.value?.name ?? "시야 손님 ${UserService.instance.userPublicInfo.value?.id ?? ""}"}", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100, fontFamily: "Inter"),),)),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(
                            width: maxLabelWidth,
                            child: Text("setting.user_info_phone".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)
                        ),
                        Obx(() {
                          if(UserService.instance.userPrivateInfo.value == null){
                            return BouncingButton(
                              onTap: () async {
                                var result = await Get.toNamed(AppRouter.phone_verification);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.blueGrey100,
                                        width: 1
                                    )
                                ),
                                child: Text("setting.user_info_phone_verify".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100,fontFamily: "Inter"),),
                              ),
                            );
                          }else {
                            return Expanded(child: Obx(() => Text("${UserService.instance.userPrivateInfo.value?.phone_number ?? ""}", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100, fontFamily: "Inter"),),));
                          }
                        },),


                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(
                            width: maxLabelWidth,
                            child: Text("setting.user_info_email".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)
                        ),
                        Expanded(child: Obx(() => Text("${UserService.instance.userPublicInfo.value?.email ?? ""}", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100, fontFamily: "Inter"),),)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 2, color: AppColors.blueGrey300),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("setting.sns_title".tr, style: AppThemes.headline04.copyWith(color: AppColors.blueGrey100),),
                    const SizedBox(height: 20,),
                    const Divider(height: 1,thickness: 1,color: AppColors.blueGrey800,),
                    const SizedBox(height: 20,),
                    SettingSnsIcons(),
                  ],
                ),
              ),
              const Divider(height: 2, color: AppColors.blueGrey300),
              MyPageMenuButton(title: "setting.terms_service".tr, onTap : () async {
                final url = Uri.parse("https://www.seeya-printer.com/terms/service");
                if(await canLaunchUrl(url)){
                  launchUrl(url);
                }
              },),
              MyPageMenuButton(title: "setting.terms_privacy".tr, onTap : () async {
                final url = Uri.parse("https://www.seeya-printer.com/terms/privacy");
                if(await canLaunchUrl(url)){
                  launchUrl(url);
                }
              },showDivider: false,),
              const Divider(height: 2, color: AppColors.blueGrey700,),
              const SizedBox(height: 20,),
              Center(
                child: Obx(() {
                  if(!UserService.instance.isLoginUser.value) return const SizedBox();
                  return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRouter.withdrawal);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Text("setting.withdrawal".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),),
                      )
                  );
                },),
              ),

              const SizedBox(height: 30,),

              Center(
                child: FutureBuilder(
                  future: PackageInfoUtils.getVersion(), builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return Text("v${snapshot.data}", style: const TextStyle(color: AppColors.backgroundReverse, fontSize: 12),);
                  }else {
                    return const Text("");
                  }
                },),
              ),
              const SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }

}
