import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  static void initialize(){


    var initializationsSettings = const InitializationSettings(
        android: AndroidInitializationSettings('mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings()
    );


    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (details) async {
        print("foreground 알림을 클릭");
        // if (details.payload == null) return;
        // 알림으로 받은 Payload를 활용하여 알림을 클릭했을 때 동작을 여기서 제어
      },
    );
  }


  static void createNotification(RemoteMessage message) async {

    try {

      AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
        '시야 알림 기본',
        '시야 알림',

        playSound: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high,
      );
      const iosNotificatonDetail = DarwinNotificationDetails();
      var notification= NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosNotificatonDetail
      );

      if(message.notification != null && Platform.isAndroid){
        await flutterLocalNotificationsPlugin.show(
          message.notification!.hashCode,
          message.notification!.title,
          message.notification!.body,
          notification,
          payload: jsonEncode(message.toMap())
        );
      }


    }on Exception catch (e) {

      Logger().e("create notification error ::: $e");

    }
  }
}