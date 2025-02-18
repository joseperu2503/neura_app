import 'package:flutter/material.dart';
import 'package:neura_app/app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'Mulish',
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.white),
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        accentColor: Colors.black12,
        backgroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.black12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white38,
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.brandColorDefault,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          disabledBackgroundColor: AppColors.neutralLine,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.brandColorDefault,
      ),
      dialogTheme: DialogThemeData(backgroundColor: AppColors.white),
    );
  }
}
