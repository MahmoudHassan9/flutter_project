import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

abstract class AppTheme {
  static ThemeData light = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blue,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.blue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      primary: Colors.blue,
    ),
  );
}
