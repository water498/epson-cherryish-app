import 'package:intl/intl.dart';

abstract class FormatUtils {
  FormatUtils._();

  static String timestampToFormatString(int? timestamp, String format) {
    if(timestamp == null){
      return "";
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  }


}