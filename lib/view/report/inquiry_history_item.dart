import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/utils/format_utils.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_router.dart';
import '../../constants/app_themes.dart';
import 'inquiry_status/inquiry_statuses_with_date.dart';

class InquiryHistoryItem extends StatelessWidget {

  final int index;
  final InquiryItemModel inquiryItem;
  final VoidCallback onItemClick;

  const InquiryHistoryItem({
    required this.index,
    required this.inquiryItem,
    required this.onItemClick,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onItemClick();
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            InquiryStatusesWithDate(inquiryItem: inquiryItem,),
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
                          "image_path" : Uri.encodeFull("${AppSecret.s3url}${inquiryItem.report_filepath}"),
                          "hero_tag" : "inquiry_image_viewer$index",
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
                          tag: "inquiry_image_viewer$index",
                          child: CachedNetworkImage(
                            imageUrl: Uri.encodeFull("${AppSecret.s3url}${inquiryItem.report_filepath}"),
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Image.asset("assets/image/loading02.gif"),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${FormatUtils.formatDateTimeToYYYYMMDDHHMM(inquiryItem.printing_date)} 인쇄 완료", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey400),),
                        Text(inquiryItem.event_name, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100), maxLines: 2, overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}
