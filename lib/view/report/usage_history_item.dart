import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_themes.dart';

import '../../constants/app_router.dart';

class UsageHistoryItem extends StatelessWidget {
  const UsageHistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                color: AppColors.primary900,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text("대기중", style: AppThemes.bodySmall.copyWith(color: AppColors.primary400),),
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
                      Text("이벤트명은 여기에 이렇게 두줄까지만 표시되도록 해주세요. 두 줄을 넘어갈 경우엔 ...처리해주세요.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100), maxLines: 2, overflow: TextOverflow.ellipsis,),
                      const Expanded(child: SizedBox()),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRouter.error_report);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.blueGrey600,
                                  width: 2
                                )
                              ),
                              child: Text("에러 리포트하기", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),)
                            )
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.blueGrey600,
                                      width: 2
                                  )
                              ),
                              child: Text("재출력", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey200),)
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
