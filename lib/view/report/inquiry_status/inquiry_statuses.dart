import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeya/utils/utils.dart';
import 'package:seeya/view/report/inquiry_status/inquiry_status_accepted.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_themes.dart';
import '../../../data/model/models.dart';
import 'inquiry_status_denied.dart';
import 'inquiry_status_pending.dart';

enum InquiryStatus { pending, accepted, denied }

class InquiryStatuses extends StatelessWidget {
  final InquiryItemModel inquiryItem;

  const InquiryStatuses({
    required this.inquiryItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _buildStatus();
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

  InquiryStatus _getInquiryStatus() {
    switch (inquiryItem.report_status) {
      case "pending":
        return InquiryStatus.pending;
      case "accepted":
        return InquiryStatus.accepted;
      case "denied":
        return InquiryStatus.denied;
      default:
        return InquiryStatus.pending; // default value in case of unknown status
    }
  }

}