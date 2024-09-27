import 'package:intl/intl.dart';

abstract class FormatUtils {
  FormatUtils._();

  // static String format01 = "MM.dd HH:mm";
  // static String format02 = "MM월dd일 HH:mm";
  // static String format03 = "yy.MM.dd";

  static String timestampToFormatString(int? timestamp, String format) {
    if(timestamp == null){
      return "";
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  }



  static bool isEmailValid(String email) {
    // 이메일 정규식 패턴
    String emailPattern = r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+';

    RegExp regExp = RegExp(emailPattern);

    return regExp.hasMatch(email);
  }



  static String formatWithComma(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }


  static String? formatDate01(DateTime? date) {
    return date == null ? null : '${date.year.toString().padLeft(4, '0')}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }



  static String formatSecondsToMMSS(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }



}