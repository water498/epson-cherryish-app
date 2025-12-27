import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seeya/core/config/app_colors.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/common_widget.dart';
import 'package:seeya/view/report/inquiry_history_item.dart';
import 'package:seeya/view/report/usage_history_item.dart';

import '../../core/config/app_themes.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

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
        title: Text("report.title".tr, style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.selectedTabIndex(0);
                  },
                  child: Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: controller.selectedTabIndex.value == 0 ? Colors.white : Colors.transparent,
                      child: Center(child: Text("report.tab_bar_menu1".tr, style: AppThemes.headline05.copyWith(color: controller.selectedTabIndex.value == 0 ? AppColors.blueGrey100 : AppColors.blueGrey400),)),
                    );
                  },),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.selectedTabIndex(1);
                  },
                  child: Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: controller.selectedTabIndex.value == 0 ? Colors.transparent : Colors.white,
                      child: Center(child: Text("report.tab_bar_menu2".tr, style: AppThemes.headline05.copyWith(color: controller.selectedTabIndex.value == 0 ? AppColors.blueGrey400 : AppColors.blueGrey100),)),
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
                if(controller.selectedTabIndex.value == 0){
                  await controller.fetchPrintHistories();
                } else {
                  await controller.fetchReports();
                }
              },
              backgroundColor: Colors.white,
              child: Obx(() => IndexedStack(
                index: controller.selectedTabIndex.value,
                children: [
                  page1(),
                  page2(),
                ],
              ),),
            ),
          )


        ],
      ),
    );


  }

  Widget page1(){
    return ListView.builder(
      itemCount: controller.usageHistoryList.length,
      itemBuilder: (context, index) {

        var historyItem = controller.usageHistoryList[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.white,
          child: UsageHistoryItem(
            index: index,
            printHistory: historyItem,
            reportErrorClick: () {
              Get.toNamed(AppRouter.error_report, arguments: historyItem);
            },
            reprintClick: () {
              controller.showReprintAlert(context, historyItem);
            },
          ),
        );
      },
    );
  }

  Widget page2(){
    return ListView.builder(
      itemCount: controller.inquiryList.length,
      itemBuilder: (context, index) {

        var inquiryItem = controller.inquiryList[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.white,
          child: InquiryHistoryItem(
            index: index,
            inquiryItem: inquiryItem,
            onItemClick: () {
              Get.toNamed(AppRouter.inquiry_detail, arguments: inquiryItem.id);
            },
          ),
        );
      },
    );
  }

}
