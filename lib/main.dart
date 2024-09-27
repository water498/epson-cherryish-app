import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/service/services.dart';

import 'constants/app_colors.dart';
import 'constants/app_prefs_keys.dart';
import 'constants/app_secret.dart';
import 'constants/app_themes.dart';
import 'firebase_options.dart';


// firebase fcm background handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


// firebase fcm foreground handler
initializeNotification() async {

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: true,
    sound: true,
  );

  var setting = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Logger().d("foreground _configureFirebaseMessaging title ::: ${message.notification?.title} body ::: ${message.notification?.body}");
    LocalNotificationService.createNotification(message);
  });

  Logger().d('User granted fcm permission: ${setting.authorizationStatus}');

}










void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  // app orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);


  // init firebase
  try{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Disable analytics & crashlytics when in debug mode !kDebugMode
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);
    Logger().d("Firebase initialized !");
  }catch (e){
    Logger().e("Failed to initialize Firebase: $e");
  }


  // fcm token
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  Logger().d("fcmToken ::: ${fcmToken}");
  if(Platform.isIOS || Platform.isMacOS){
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    Logger().d("apnsToken ::: ${apnsToken}");
  }



  LocalNotificationService.initialize();
  // add fcm background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // fcm
  // add fcm foreground handler
  initializeNotification();



  // init kakaoSdk
  KakaoSdk.init(nativeAppKey: AppSecret.kakaoNativeAppKey);


  // init GetXServices
  UserService.initialize();



  // init preferences
  await AppPreferences().init();
  AppPreferences().prefs?.setString(AppPrefsKeys.fcmToken, fcmToken ?? ""); // fcmToken 삽입

  runApp(const MyApp());
}












class MyApp extends StatelessWidget {

  const MyApp({
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary400,
          background: AppColors.backgroundReverse,
        ),
        // useMaterial3: false,
        appBarTheme: AppThemes.appBarTheme,
        textTheme: AppThemes.textTheme,
        inputDecorationTheme: AppThemes.inputDecorationTheme,
        scaffoldBackgroundColor: AppColors.background,
        dialogTheme: AppThemes.dialogTheme,
        floatingActionButtonTheme: AppThemes.fabTheme,
        expansionTileTheme: AppThemes.expansionTileTheme,
        textButtonTheme: TextButtonThemeData(
          style: ElevatedButton.styleFrom(splashFactory: NoSplash.splashFactory,), // disable ripple
        ),
        fontFamily: "DungGeunMo",
      ),
      initialRoute: AppRouter.custom_splash,
      getPages: AppRouter.routes,
    );
  }
}