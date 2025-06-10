import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_themes.dart';

class InquiryStatusDenied extends StatelessWidget {
  const InquiryStatusDenied({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFDDDD),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text("inquiry_detail.status_denied".tr, style: AppThemes.bodySmall.copyWith(color: AppColors.error),),
    );
  }
}
