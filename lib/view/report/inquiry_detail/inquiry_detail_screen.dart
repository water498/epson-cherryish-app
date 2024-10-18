import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/controller/inquiry_detail_controller.dart';
import 'package:seeya/view/report/inquiry_status/inquiry_statuses.dart';

import '../../../constants/app_themes.dart';
import '../../../utils/utils.dart';


enum InquiryStatus { pending, accepted, denied }

class InquiryDetailScreen extends GetView<InquiryDetailController> {
  const InquiryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Color lineColor = AppColors.blueGrey700;
    Color checkBoxBorderColor = AppColors.blueGrey700;
    Color checkBoxFillColor = AppColors.blueGrey800;
    Color iconColor = Colors.white;
    String svgPath = "";


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
      body: Obx(() {
        if(controller.isLoading.value) return const SizedBox();
        if(controller.inquiryItem == null) return const SizedBox();







        switch (_getInquiryStatus(controller.inquiryItem!.report_status)) {
          case InquiryStatus.pending:
            break;
          case InquiryStatus.accepted:{
            lineColor = AppColors.primary400;
            checkBoxBorderColor = AppColors.primary400;
            checkBoxFillColor = AppColors.primary500;
            iconColor = Colors.white;
            svgPath = "assets/image/ic_check_small.svg";
            break;
          }
          case InquiryStatus.denied:{
            lineColor = AppColors.error;
            checkBoxBorderColor = AppColors.error;
            checkBoxFillColor = const Color(0xffFFDDDD);
            iconColor = Colors.transparent;
            svgPath = "assets/image/ic_warning_small_red.svg";
            break;
          }

        }







        return Scrollbar(
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
                            Expanded(child: Divider(thickness: 2,color: lineColor,)),
                            const SizedBox(width: 4,),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  color: checkBoxFillColor,
                                  border: Border.all(
                                    color: checkBoxBorderColor,
                                    width: 2,
                                  )
                              ),
                              child: svgPath.isEmpty ? const SizedBox() : SvgPicture.asset(svgPath, colorFilter: svgPath.contains("red") ? null : ColorFilter.mode(iconColor, BlendMode.srcIn),),
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
                            _buildStatusTextWidget(),
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
                            const Expanded(child: SizedBox()),
                            InquiryStatuses(inquiryItem: controller.inquiryItem!),
                          ],
                        ),
                        const SizedBox(height: 12,),
                        const Divider(height: 2, thickness: 2, color: AppColors.blueGrey800,),
                        const SizedBox(height: 12,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset("assets/image/ic_arrow_right_small.svg"),
                            Expanded(child: Text(_getAnswer(), style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },),
    );
  }



  // status별 답변
  String _getAnswer() {
    switch (_getInquiryStatus(controller.inquiryItem!.report_status)) {
      case InquiryStatus.pending:
        return "진행중입니다. 조금만 기다려주시면 빠르게 진행 도와드리겠습니다.";
      case InquiryStatus.accepted:
        return "${FormatUtils.formatDateTimeToYYYYMMDDHHMM(controller.inquiryItem?.report_completed_date)}\n환불처리 완료되었습니다.";
      case InquiryStatus.denied:
        return "${controller.inquiryItem?.report_answer ?? ""}";
    }
  }

  // 체크 박스 밑에 텍스트
  Widget _buildStatusTextWidget() {
    switch (_getInquiryStatus(controller.inquiryItem!.report_status)) {
      case InquiryStatus.pending:
        return Text("환불 완료", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey200),);
      case InquiryStatus.accepted:
        return Text("환불 완료", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey200),);
      case InquiryStatus.denied:
        return Text("환불 반려", style: AppThemes.bodySmall.copyWith(color: AppColors.error),);
    }
  }

  InquiryStatus _getInquiryStatus(String status) {
    switch (status) {
      case "pending":
        return InquiryStatus.pending;
      case "accepted":
        return InquiryStatus.accepted;
      case "denied":
        return InquiryStatus.denied;
      default:
        return InquiryStatus.pending; // default value in case of unknown status
    }
  }


}
