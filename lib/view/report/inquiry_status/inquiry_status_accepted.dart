import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_themes.dart';

class InquiryStatusAccepted extends StatelessWidget {
  const InquiryStatusAccepted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blueGrey700,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text("inquiry_detail.status_accepted".tr, style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey300),),
    );
  }
}
