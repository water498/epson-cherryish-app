import 'package:flutter/material.dart';
import 'package:seeya/view/report/history_status/status_completed.dart';
import 'package:seeya/view/report/history_status/status_error.dart';
import 'package:seeya/view/report/history_status/status_error_reported.dart';
import 'package:seeya/view/report/history_status/status_pending.dart';
import 'package:seeya/view/report/history_status/status_wait.dart';

import '../../../data/model/models.dart';

enum PrintHistoryStatus { wait, pending, completed, error, errorReported }

class HistoryStatuses extends StatelessWidget {
  final PrintHistoryModel printHistory;

  const HistoryStatuses({
    required this.printHistory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _buildStatus();
  }

  Widget _buildStatus() {
    switch (_getPrintHistoryStatus()) {
      case PrintHistoryStatus.wait:
        return const StatusWait();
      case PrintHistoryStatus.pending:
        return const StatusPending();
      case PrintHistoryStatus.completed:
        return const StatusCompleted();
      case PrintHistoryStatus.error:
        return const StatusError();
      case PrintHistoryStatus.errorReported:
        return const StatusErrorReported();
    }
  }

  PrintHistoryStatus _getPrintHistoryStatus() {
    switch (printHistory.status) {
      case "wait":
        return PrintHistoryStatus.wait;
      case "pending":
        return PrintHistoryStatus.pending;
      case "completed":
        return PrintHistoryStatus.completed;
      case "error":
        return PrintHistoryStatus.error;
      case "error-reported":
        return PrintHistoryStatus.errorReported;
      default:
        return PrintHistoryStatus.wait; // Default value in case of unknown status
    }
  }
}