import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_themes.dart';

class StatusError extends StatelessWidget {
  const StatusError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFDDDD),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text("에러", style: AppThemes.bodySmall.copyWith(color: AppColors.error),),
    );
  }
}
