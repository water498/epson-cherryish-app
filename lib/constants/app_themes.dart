import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

abstract class AppThemes {
  AppThemes._();

  static const appBarTheme = AppBarTheme(
    toolbarHeight: 80,
    color: AppColors.background,
    titleTextStyle: TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
      fontFamily: "DungGeunMo",
    ),
    iconTheme: IconThemeData(
        color: AppColors.backgroundReverse
    ),
    surfaceTintColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );

  static const textTheme = TextTheme(

    bodySmall: TextStyle(color: AppColors.backgroundReverse),
    bodyMedium: TextStyle(color: AppColors.backgroundReverse),
    bodyLarge: TextStyle(color: AppColors.backgroundReverse),
    displaySmall: TextStyle(color: AppColors.backgroundReverse),
    displayMedium: TextStyle(color: AppColors.backgroundReverse),
    displayLarge: TextStyle(color: AppColors.backgroundReverse),
    labelSmall: TextStyle(color: AppColors.backgroundReverse),
    labelMedium: TextStyle(color: AppColors.backgroundReverse),
    labelLarge: TextStyle(color: AppColors.backgroundReverse),
    titleSmall: TextStyle(color: AppColors.backgroundReverse),
    titleMedium: TextStyle(color: AppColors.backgroundReverse),
    titleLarge: TextStyle(color: AppColors.backgroundReverse),
    headlineSmall: TextStyle(color: AppColors.backgroundReverse),
    headlineMedium: TextStyle(color: AppColors.backgroundReverse),
    headlineLarge: TextStyle(color: AppColors.backgroundReverse),
  );

  // textfiled 밑줄 색상
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      hintStyle: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey600),
      disabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.backgroundReverse),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.backgroundReverse),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.backgroundReverse),
      ),
      counterStyle: const TextStyle(color: AppColors.backgroundReverse), // 글자수 제한(?) 색
  );

  static const dialogTheme = DialogTheme(
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent
  );

  static const fabTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary400,
  );

  static const expansionTileTheme = ExpansionTileThemeData(
      iconColor: AppColors.backgroundReverse,
      collapsedIconColor: AppColors.backgroundReverse
  );









  static const headline01 = TextStyle(
      fontSize: 28,
      height: 1.71428,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.4
  );

  static const headline02 = TextStyle(
      fontSize: 24,
      height: 1.66667,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.3
  );

  static const headline03 = TextStyle(
      fontSize: 20,
      height: 1.6,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.3
  );

  static const headline04 = TextStyle(
      fontSize: 18,
      height: 1.77778,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.3
  );

  static const headline05 = TextStyle(
      fontSize: 16,
      height: 1.75,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.3
  );

  static const bodyMedium = TextStyle(
      fontSize: 14,
      height: 1.71428,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.3
  );

  static const bodySmall = TextStyle(
      fontSize: 12,
      height: 1.66667,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.3
  );



}