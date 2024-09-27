import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/common_widget.dart';
import 'package:seeya/view/report/inquiry_history_item.dart';
import 'package:seeya/view/report/usage_history_item.dart';

import '../../constants/app_themes.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ReportController());

    return Scaffold(
      backgroundColor: AppColors.blueGrey800,
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
        title: Text("에러 리포트", style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.isUsageSelected(true);
                  },
                  child: Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: controller.isUsageSelected.value ? Colors.white : Colors.transparent,
                      child: Center(child: Text("이용 내역", style: AppThemes.headline05.copyWith(color: controller.isUsageSelected.value ? AppColors.blueGrey100 : AppColors.blueGrey400),)),
                    );
                  },),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.isUsageSelected(false);
                  },
                  child: Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: controller.isUsageSelected.value ? Colors.transparent : Colors.white,
                      child: Center(child: Text("문의 내역", style: AppThemes.headline05.copyWith(color: controller.isUsageSelected.value ? AppColors.blueGrey400 : AppColors.blueGrey100),)),
                    );
                  },),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8,),


          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                return Future.delayed(const Duration(milliseconds: 1000));
              },
              backgroundColor: Colors.white,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.white,
                    child: Column(
                      children: [
                        UsageHistoryItem(),
                        InquiryHistoryItem(),
                      ],
                    ),
                  );
                },
              ),
            ),
          )


        ],
      ),
    );
  }

}
