import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_themes.dart';

class StatusCompleted extends StatelessWidget {
  const StatusCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blueGrey700,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text("출력 완료", style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),
    );
  }
}
