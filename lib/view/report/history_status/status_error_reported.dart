import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_themes.dart';

class StatusErrorReported extends StatelessWidget {
  const StatusErrorReported({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFDDDD),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text("report.item_status_reported".tr, style: AppThemes.bodySmall.copyWith(color: AppColors.error),),
    );
  }
}
