import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_themes.dart';

class InquiryStatusPending extends StatelessWidget {
  const InquiryStatusPending({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffE1FFE8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text("진행중", style: AppThemes.bodySmall.copyWith(color: AppColors.success),),
    );
  }
}
