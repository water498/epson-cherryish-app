import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_colors.dart';
import '../../../core/config/app_themes.dart';

class StatusWait extends StatelessWidget {
  const StatusWait({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary900,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text("report.item_status_wait".tr, style: AppThemes.bodySmall.copyWith(color: AppColors.primary400),),
    );
  }
}
