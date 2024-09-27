import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/controller/inquiry_detail_controller.dart';

import '../../../constants/app_themes.dart';

class InquiryDetailScreen extends GetView<InquiryDetailController> {
  const InquiryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(InquiryDetailController());

    return Scaffold(
      backgroundColor: AppColors.blueGrey800,
      appBar: AppBar(
        backgroundColor: AppColors.blueGrey800,
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
        title: Text("문의 내역", style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 44),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 28, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.blueGrey700,
                      width: 2,
                    )
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 10,),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              border: Border.all(
                                color: AppColors.primary400,
                                width: 2,
                              )
                            ),
                            child: SvgPicture.asset("assets/image/ic_check_small.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          ),
                          const SizedBox(width: 4,),
                          Expanded(child: Divider(thickness: 2,color: AppColors.primary400,)),
                          const SizedBox(width: 4,),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                                color: AppColors.primary500,
                                border: Border.all(
                                  color: AppColors.primary400,
                                  width: 2,
                                )
                            ),
                            child: SvgPicture.asset("assets/image/ic_check_small.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          ),
                          const SizedBox(width: 4,),
                          Expanded(child: Divider(thickness: 2,color: AppColors.primary400,)),
                          const SizedBox(width: 4,),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                                color: AppColors.primary500,
                                border: Border.all(
                                  color: AppColors.primary400,
                                  width: 2,
                                )
                            ),
                            child: SvgPicture.asset("assets/image/ic_check_small.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          ),
                          const SizedBox(width: 10,),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("에러 접수", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey200),),
                          Text("진행중", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey200),),
                          Text("환불 완료", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey200),),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 12,),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.blueGrey700,
                        width: 2,
                      )
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("진행 상태", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),),
                          const Expanded(child: const SizedBox()),
                          Container(
                            color: const Color(0xffE1FFE8),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text("진행중", style: AppThemes.bodySmall.copyWith(color: AppColors.success),)
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Divider(height: 2, thickness: 2, color: AppColors.blueGrey800,),
                      const SizedBox(height: 12,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/image/ic_arrow_right_small.svg"),
                          Expanded(child: Text("진행중입니다. 조금만 기다려주시면 빠르게 진행 도와드리겠습니다.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
