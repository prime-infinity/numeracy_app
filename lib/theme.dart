import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color.fromARGB(255, 160, 104, 253);
  static Color primaryAccent = const Color.fromARGB(255, 223, 209, 246);
  static Color successColor = const Color.fromARGB(255, 19, 250, 168);
  static Color failureColor = const Color.fromARGB(255, 255, 126, 128);
  static Color successBorder = const Color(0xFF388E3C);
  static Color failureBorder = const Color(0xFFD32F2F);
  static Color black = const Color.fromARGB(255, 19, 18, 18);
  static Color white = const Color.fromARGB(255, 246, 246, 243);
  static Color cardGrey = const Color.fromARGB(255, 218, 218, 218);
}

class AppDimensions {
  static double buttonHeight = 80;
  static double cardRadius = 28;
}

ThemeData primaryTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
  textTheme: const TextTheme(
      bodySmall: TextStyle(
          fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(
          fontSize: 60, letterSpacing: 1, fontWeight: FontWeight.w700),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontSize: 35, fontWeight: FontWeight.w600)),
);
