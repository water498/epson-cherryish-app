import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppThemes {
  AppThemes._();

  static const appBarTheme = AppBarTheme(
    color: AppColors.background,
    titleTextStyle: TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
        color: AppColors.backgroundReverse
    ),
    surfaceTintColor: Colors.transparent,
    foregroundColor: Colors.transparent,
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
  static const inputDecorationTheme = InputDecorationTheme(
      hintStyle: TextStyle(color: Color(0xFFB4B4B4)),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.backgroundReverse),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.backgroundReverse),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.backgroundReverse),
      ),
      counterStyle: TextStyle(color: AppColors.backgroundReverse) // 글자수 제한(?) 색
  );

  static const dialogTheme = DialogTheme(
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent
  );

  static const fabTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.main,
  );

  static const expansionTileTheme = ExpansionTileThemeData(
      iconColor: AppColors.backgroundReverse,
      collapsedIconColor: AppColors.backgroundReverse
  );

}