import 'package:firebase_analytics/firebase_analytics.dart';

class GAUtils {
  GAUtils._();

  static Future<void> sendAnalyticsEvent(String eventName, Map<String,Object>? params) async {

    await FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: params
    );

  }

}