import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/config/app_themes.dart';

class StatusCompleted extends StatelessWidget {
  const StatusCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blueGrey700,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text("report.item_status_completed".tr, style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),
    );
  }
}
