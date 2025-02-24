import 'package:flutter/material.dart';
import 'package:neura_app/app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'Roboto',
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.dark1,
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
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          disabledBackgroundColor: AppColors.dark5,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
      ),
      dialogTheme: DialogThemeData(backgroundColor: AppColors.white),
    );
  }
}
