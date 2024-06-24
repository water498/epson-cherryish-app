import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/service/services.dart';

import 'constants/app_colors.dart';
import 'constants/app_prefs_keys.dart';
import 'constants/app_themes.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  // app orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);


  // fcm token
  String? fcmToken = Platform.isIOS || Platform.isMacOS ? "temp fcm token":"temp fcm token";
  // await FirebaseMessaging.instance.getAPNSToken() :
  // await FirebaseMessaging.instance.getToken();
  Logger().d("fcmToken ${fcmToken}");



  // init preferences
  await AppPreferences().init();
  int? userId = AppPreferences().prefs?.getInt(AppPrefsKeys.userId);
  AppPreferences().prefs?.setString(AppPrefsKeys.fcmToken, fcmToken ?? ""); // fcmToken 삽입

  runApp(MyApp(userId: userId,));
}

class MyApp extends StatelessWidget {
  final int? userId;

  const MyApp({
    required this.userId,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppColors.main,
            background: AppColors.backgroundReverse,
          ),
          // useMaterial3: false,
          appBarTheme: AppThemes.appBarTheme,
          // fontFamily: "NPSfont",
          textTheme: AppThemes.textTheme,
          inputDecorationTheme: AppThemes.inputDecorationTheme,
          scaffoldBackgroundColor: AppColors.background,
          dialogTheme: AppThemes.dialogTheme,
          floatingActionButtonTheme: AppThemes.fabTheme,
          expansionTileTheme: AppThemes.expansionTileTheme,
          textButtonTheme: TextButtonThemeData(
            style: ElevatedButton.styleFrom(splashFactory: NoSplash.splashFactory,), // disable ripple
          )
      ),
      initialRoute: userId == null ? AppRouter.login : AppRouter.root,
      getPages: AppRouter.routes,
    );
  }
}