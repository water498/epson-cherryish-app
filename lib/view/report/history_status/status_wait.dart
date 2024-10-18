import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_themes.dart';

class StatusWait extends StatelessWidget {
  const StatusWait({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary900,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text("대기중", style: AppThemes.bodySmall.copyWith(color: AppColors.primary400),),
    );
  }
}
