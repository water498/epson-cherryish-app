import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/controller/controllers.dart';

import '../../constants/app_themes.dart';

class QnaScreen extends GetView<QnaController> {
  const QnaScreen({super.key});

  @override
  Widget build(BuildContext context) {

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
        title: Text("자주 묻는 질문", style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),

          if(false)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.blueGrey800,
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: AppColors.blueGrey700,
                  width: 2,
                )
              )
            ),
            child: TabBar(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              controller: controller.tabController,
              tabs: controller.tabs,
              isScrollable: true,
              labelColor: AppColors.primary400,
              unselectedLabelColor: AppColors.blueGrey500,
              indicatorColor: AppColors.primary400,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              tabAlignment: TabAlignment.start,
              labelStyle: AppThemes.bodyMedium.copyWith(fontFamily: "DungGeunMo"),
              onTap: (value) {

              },
            ),
          ),
          Obx(() {

            if(controller.qnaList.isEmpty) return const SizedBox();

            return Expanded(
              child: ListView(
                children: [
                  ListView.builder(
                    itemCount: controller.qnaList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {

                      var qna = controller.qnaList[index];

                      return Container(
                        decoration: BoxDecoration(
                            color: AppColors.blueGrey800,
                            border: Border(
                              top: BorderSide(
                                  width: index == 0 ? 2 : 1, color: AppColors.blueGrey700
                              ),
                              bottom: BorderSide(
                                  width: index == controller.qnaList.length - 1 ? 2 : 1, color: AppColors.blueGrey700
                              ),
                            )
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: AppColors.blueGrey700,),
                          child: ExpansionTile(


                            trailing: const SizedBox.shrink(), // 아이콘 제거
                            expandedAlignment: Alignment.centerLeft,
                            collapsedBackgroundColor: Colors.white,
                            tilePadding: EdgeInsets.zero,

                            title: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              child: Text(qna.title, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100),),
                            ),
                            children: [
                              Container(
                                color: AppColors.blueGrey800,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        color: AppColors.blueGrey800,
                                        padding: const EdgeInsets.symmetric(horizontal: 24),
                                        child: const Divider(height: 2, thickness: 2, color: AppColors.blueGrey700,)
                                    ),
                                    Padding(
                                      padding : const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                                      child: Text(qna.answer, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200)),
                                    )
                                  ],
                                ),
                              )
                            ],

                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: SelectableText("이외의 문의는\n고객센터 이메일(info@seeya-printer.com)으로\n문의 바랍니다.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300, fontFamily: "Inter"),textAlign: TextAlign.center,),
                  ),
                ],
              ),
            );
          },)

        ],
      ),
    );
  }

}
