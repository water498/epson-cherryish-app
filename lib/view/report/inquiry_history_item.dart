import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_router.dart';
import '../../constants/app_themes.dart';

class InquiryHistoryItem extends StatelessWidget {
  const InquiryHistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(AppRouter.inquiry_detail);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  color: Color(0xffE1FFE8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text("진행중", style: AppThemes.bodySmall.copyWith(color: AppColors.success),),
                ),
                Expanded(child: const SizedBox()),
                Text("2000.00.00 14:00 인쇄 전송", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey400),)
              ],
            ),
            const SizedBox(height: 12,),
            const Divider(thickness: 2, color: AppColors.blueGrey800,),
            const SizedBox(height: 12,),
            Row(
              children: [
                CachedNetworkImage(imageUrl: "https://i0.wp.com/digital-photography-school.com/wp-content/uploads/2013/07/ar-09.jpg?ssl=1", height: 110,),
                const SizedBox(width: 12,),
                Expanded(
                  child: SizedBox(
                    height: 110,
                    child: Column(
                      children: [
                        Text("2024.08.01 14:00 인쇄 완료", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey400),),
                        Text("이벤트명은 여기에 이렇게 두줄까지만 표시되도록 해주세요. 두 줄을 넘어갈 경우엔 ...처리해주세요.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100), maxLines: 2, overflow: TextOverflow.ellipsis,),
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
