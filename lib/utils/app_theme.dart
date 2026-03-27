import 'package:flutter/material.dart';
import 'package:new_lion/utils/app_colors.dart';
import 'package:new_lion/utils/fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Shared AppBar style ──
  static AppBarTheme _appBarTheme({required Color backgroundColor}) =>
      AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.en,
        ),
        iconTheme: IconThemeData(color: AppColors.white),
      );

  // ── Light Theme ──
  static ThemeData get light => ThemeData(
    fontFamily: Fonts.en,
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.lightText,
      surface: AppColors.surface,
      onPrimary: AppColors.white,
      onSurface: AppColors.white,
    ),
    cardColor: AppColors.cardBg,
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: AppColors.white),
      bodySmall: TextStyle(color: AppColors.textMuted),
    ),
    appBarTheme: _appBarTheme(backgroundColor: AppColors.lightBg),
  );

  // ── Dark Theme ──
  static ThemeData get dark => ThemeData(
    fontFamily: Fonts.en,
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.darkBg,
    scaffoldBackgroundColor: AppColors.darkCard,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkBg,
      secondary: AppColors.darkBg,
      surface: AppColors.cardBg,
    ),
    appBarTheme: _appBarTheme(backgroundColor: AppColors.darkBg),
  );
}
