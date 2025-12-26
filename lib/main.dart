import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/service/services.dart';
import 'package:seeya/utils/utils.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import 'constants/app_colors.dart';
import 'constants/app_prefs_keys.dart';
import 'constants/app_secret.dart';
import 'constants/app_themes.dart';
import 'firebase_options.dart';
import 'languages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


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
    alert: true,
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


  // control android global back press
  BackButtonInterceptor.add((stopDefaultButtonEvent, routeInfo) {
    if(LoadingOverlay.overlayEntry != null) return true;
    return false;
  },);


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


  // ********** Delay 때문에 Custom Splash 로 이동 **********
  // fcm token
  // if(Platform.isIOS){
  //   String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  //   if (apnsToken == null) {
  //     Logger().d("APNS token is not set yet");
  //     await Future.delayed(const Duration(seconds: 1)); // apns 콜백 받고 getToken을 호출해야되는데 따로 콜백이 없음 stackoverflow 대처
  //     apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  //   } else {
  //     Logger().d("APNS token: ${apnsToken}");
  //   }
  // }
  //
  // String? fcmToken = await FirebaseMessaging.instance.getToken();
  // Logger().d("fcmToken ::: ${fcmToken}");




  LocalNotificationService.initialize();
  // add fcm background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // fcm
  // add fcm foreground handler
  initializeNotification();



  // init kakaoSdk
  KakaoSdk.init(nativeAppKey: AppSecret.kakaoNativeAppKey);

  // init naver login sdk
  NaverLoginSDK.initialize(
    urlScheme: 'seeyanaverlogin',
    clientId: 'E1yxVG4Lk8q7jXbgWLGv',
    clientSecret: 'JwkZ2DJ32r',
    clientName: '시야'
  );

  // init GetXServices
  UserService.initialize();

  // init libphonenumber
  await init();

  // init preferences
  await AppPreferences().init();
  // ********** Delay 때문에 Custom Splash 로 이동 **********
  // AppPreferences().prefs?.setString(AppPrefsKeys.fcmToken, fcmToken ?? ""); // fcmToken 삽입

  FileUtils.clearTempDirExceptLibCachedImage();
  FileUtils.clearDocumentDir();

  runApp(const MyApp());
}












class MyApp extends StatelessWidget {

  const MyApp({
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      // 국가 코드 선택 번역
      supportedLocales: [
        Locale("ko"),
        Locale("ja"),
        Locale("en"),
      ],
      localizationsDelegates: const [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      fallbackLocale: const Locale('ko', 'KR'),// 언어 설정이 없을 경우 영어로 설정
      translations: Languages(), // 번역 파일 지정
      locale: Get.deviceLocale, // 기기의 언어 설정을 따라감
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