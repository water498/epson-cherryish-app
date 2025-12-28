import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seeya/core/config/app_colors.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/core/config/app_secret.dart';
import 'package:seeya/core/data/enum/enums.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/seeya_cached_image.dart';

import '../../core/config/app_themes.dart';

class PrintHistoryScreen extends GetView<PrintHistoryController> {
  const PrintHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

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
        title: Text("print_history.title".tr, style: AppThemes.headline04.copyWith(color: Colors.black, height: 0),),
      ),
      body: Obx(() {
        if(!controller.isLoadFinish.value) return const SizedBox();

        if(controller.historyList.isEmpty){
          return Center(
            child: Text("print_history.empty".tr)
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: controller.historyList.length,
          itemBuilder: (context, index) {
            final history = controller.historyList[index];

            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRouter.image_viewer,
                  arguments: {
                    "image_path": Uri.encodeFull("${AppSecret.s3url}${history.originalImageFilepath}"),
                    "hero_tag": "print_history_viewer$index",
                  }
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 썸네일 이미지
                      Hero(
                        tag: "print_history_viewer$index",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: SeeyaCachedImage(
                              imageUrl: Uri.encodeFull("${AppSecret.s3url}${history.thumbnailImageFilepath}"),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // 정보 영역
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 상태 뱃지
                            _buildStatusChip(history.status),
                            const SizedBox(height: 6),

                            // 이벤트명
                            Text(
                              history.event?.eventName ?? "print_history.no_event_name".tr,
                              style: AppThemes.bodyMedium.copyWith(
                                color: AppColors.blueGrey100,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            // 인쇄 요청 시간
                            if (history.printingRequestDate != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: AppColors.blueGrey400,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('yyyy.MM.dd HH:mm').format(history.printingRequestDate!),
                                    style: AppThemes.bodySmall.copyWith(
                                      color: AppColors.blueGrey400,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusChip(PrintQueueStatus status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case PrintQueueStatus.completed:
        backgroundColor = AppColors.primary400.withOpacity(0.15);
        textColor = AppColors.primary400;
        statusText = "report.item_status_completed".tr;
        break;
      case PrintQueueStatus.printing:
        backgroundColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange;
        statusText = "report.item_status_pending".tr;
        break;
      case PrintQueueStatus.wait:
        backgroundColor = AppColors.blueGrey500.withOpacity(0.15);
        textColor = AppColors.blueGrey300;
        statusText = "report.item_status_wait".tr;
        break;
      case PrintQueueStatus.error:
        backgroundColor = Colors.red.withOpacity(0.15);
        textColor = Colors.red;
        statusText = "report.item_status_error".tr;
        break;
      case PrintQueueStatus.none:
      default:
        backgroundColor = AppColors.blueGrey500.withOpacity(0.15);
        textColor = AppColors.blueGrey400;
        statusText = "report.item_status_none".tr;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusText,
        style: AppThemes.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
