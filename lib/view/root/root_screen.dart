import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/view/screens.dart';

import '../../constants/app_colors.dart';
import '../../controller/controllers.dart';


class RootScreen extends GetView<RootController> {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if(controller.currentIndex.value != 0){
            controller.currentIndex.value = 0;
          }else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                return IndexedStack(
                  index: controller.currentIndex.value,
                  children: List.generate(3, (index) => controller.tabPages[index] ?? Container()),
                );
              },),
            ),
            const Divider(height: 2, color: AppColors.blueGrey600,)
          ],
        ),
        bottomNavigationBar: Obx(() {
          return Theme(
            data: ThemeData(
              splashColor: Colors.transparent, // ripple 효과 색상
              highlightColor: Colors.transparent // long click 시 나타나는 색상
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: BottomNavigationBar(
                selectedLabelStyle: AppThemes.bodySmall,
                unselectedLabelStyle: AppThemes.bodySmall,
                selectedItemColor: AppColors.blueGrey200,
                unselectedItemColor: AppColors.blueGrey500,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                elevation: 0,
                backgroundColor: Colors.white,
                currentIndex: controller.currentIndex.value,
                onTap: (value) {
                  controller.onTabTapped(value);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/image/ic_home.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey500, BlendMode.srcIn),),
                      activeIcon: SvgPicture.asset("assets/image/ic_home.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey200, BlendMode.srcIn),),
                      label: 'bottom_nav.home'.tr
                  ),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/image/ic_map.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey500, BlendMode.srcIn),),
                      activeIcon: SvgPicture.asset("assets/image/ic_map.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey200, BlendMode.srcIn),),
                      label: 'bottom_nav.map'.tr
                  ),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/image/ic_my_page.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey500, BlendMode.srcIn),),
                      activeIcon: SvgPicture.asset("assets/image/ic_my_page.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey200, BlendMode.srcIn),),
                      label: 'bottom_nav.my_page'.tr
                  ),
                ],
              ),
            ),
          );
        },),
      ),
    );
  }

}






