import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/utils/format_utils.dart';
import 'package:seeya/view/common/common_widget.dart';
import 'package:seeya/view/common/seeya_cached_image.dart';
import 'package:seeya/view/report/history_status/history_statuses.dart';

import '../../constants/app_router.dart';

class UsageHistoryItem extends StatelessWidget {

  final int index;
  final PrintHistoryModel printHistory;
  final VoidCallback reportErrorClick;
  final VoidCallback reprintClick;

  const UsageHistoryItem({
    required this.index,
    required this.printHistory,
    required this.reportErrorClick,
    required this.reprintClick,
    super.key
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              HistoryStatuses(printHistory: printHistory),
              const Expanded(child: SizedBox()),
              Text("${printHistory.printing_date == null ? "" : "${FormatUtils.formatDateTimeToYYYYMMDDHHMM(printHistory.printing_date!)} 인쇄 전송"}", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey400),)
            ],
          ),
          const SizedBox(height: 12,),
          const Divider(thickness: 2, color: AppColors.blueGrey800, height: 2,),
          const SizedBox(height: 12,),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                      AppRouter.image_viewer,
                      arguments: {
                        "image_path" : Uri.encodeFull("${AppSecret.s3url}${printHistory.print_filepath}"),
                        "hero_tag" : "usage_history_viewer$index",
                      }
                  );
                },
                child: SizedBox(
                  height: 110,
                  child: AspectRatio(
                    aspectRatio: 2/3,
                    child: Container(
                      color: AppColors.blueGrey800,
                      child: Hero(
                        tag: "usage_history_viewer$index",
                        child: SeeyaCachedImage(
                          imageUrl: Uri.encodeFull("${AppSecret.s3url}${printHistory.print_filepath}"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12,),
              Expanded(
                child: SizedBox(
                  height: 110,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text("${printHistory.event_name}", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)
                      ),
                      const Expanded(child: SizedBox()),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              reportErrorClick();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.blueGrey600,
                                  width: 2
                                )
                              ),
                              child: Text("usage_history.report".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),)
                            )
                          ),
                          addW(8),
                          GestureDetector(
                            onTap: () {
                              reprintClick();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.blueGrey600,
                                      width: 2
                                  )
                              ),
                              child: Text("usage_history.reprint".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),)
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}
