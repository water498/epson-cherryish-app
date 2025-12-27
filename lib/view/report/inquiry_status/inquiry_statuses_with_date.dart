import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/utils/utils.dart';
import 'package:seeya/view/report/inquiry_status/inquiry_status_accepted.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/config/app_themes.dart';
import '../../../data/model/models.dart';
import 'inquiry_status_denied.dart';
import 'inquiry_status_pending.dart';

enum InquiryStatus { pending, accepted, denied }

class InquiryStatusesWithDate extends StatelessWidget {
  final InquiryItemModel inquiryItem;

  const InquiryStatusesWithDate({
    required this.inquiryItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatus(),
        const Expanded(child: SizedBox()),
        Text(
          _datetimeFromStatus(),
          style: AppThemes.bodySmall.copyWith(color: _colorFromStatus()),
        ),
        SvgPicture.asset(
          "assets/image/ic_arrow_right_small.svg",
          colorFilter: ColorFilter.mode(_colorFromStatus(), BlendMode.srcIn),
        ),
      ],
    );
  }

  Widget _buildStatus() {
    switch (_getInquiryStatus()) {
      case InquiryStatus.pending:
        return const InquiryStatusPending();
      case InquiryStatus.accepted:
        return const InquiryStatusAccepted();
      case InquiryStatus.denied:
        return const InquiryStatusDenied();
    }
  }

  Color _colorFromStatus() {
    switch (_getInquiryStatus()) {
      case InquiryStatus.pending:
        return AppColors.success;
      case InquiryStatus.accepted:
        return AppColors.blueGrey300;
      case InquiryStatus.denied:
        return AppColors.error;
    }
  }

  String _datetimeFromStatus(){
    switch(inquiryItem.report_status){
      case "pending":
        return "inquiry_detail.status_pending_with_date".trParams({'date':FormatUtils.formatDateTimeToYYYYMMDD(inquiryItem.created_date)});
      case "accepted":
        return "inquiry_detail.status_accepted_with_date".trParams({'date':FormatUtils.formatDateTimeToYYYYMMDD(inquiryItem.report_completed_date)});
      case "denied":
        return "inquiry_detail.status_denied_with_date".trParams({'date':FormatUtils.formatDateTimeToYYYYMMDD(inquiryItem.report_completed_date)});
      default:
        return "inquiry_detail.status_pending_with_date".trParams({'date':FormatUtils.formatDateTimeToYYYYMMDD(inquiryItem.created_date)});
    }
  }

  InquiryStatus _getInquiryStatus() {
    switch (inquiryItem.report_status) {
      case "pending":
        return InquiryStatus.pending;
      case "accepted":
        return InquiryStatus.accepted;
      case "denied":
        return InquiryStatus.denied;
      default:
        return InquiryStatus.pending;
    }
  }

}