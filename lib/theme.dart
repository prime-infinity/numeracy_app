import 'package:flutter/material.dart';

class AppColors {
  // Modern, professional color scheme - deep blues and teals with warm accents
  static Color primaryColor = const Color(0xFF2563EB); // Deep blue
  static Color primaryLight = const Color(0xFF3B82F6); // Lighter blue
  static Color primaryAccent = const Color(0xFFEFF6FF); // Very light blue
  static Color secondaryColor = const Color(0xFF0891B2); // Teal
  static Color secondaryLight = const Color(0xFF06B6D4); // Light teal

  // Semantic colors
  static Color successColor = const Color(0xFF10B981); // Emerald green
  static Color warningColor = const Color(0xFFF59E0B); // Amber
  static Color errorColor = const Color(0xFFEF4444); // Red

  // Neutral colors
  static Color textPrimary = const Color(0xFF111827); // Dark gray
  static Color textSecondary = const Color(0xFF6B7280); // Medium gray
  static Color textTertiary = const Color(0xFF9CA3AF); // Light gray

  static Color background = const Color(0xFFFAFAFA); // Off-white
  static Color surface = const Color(0xFFFFFFFF); // Pure white
  static Color surfaceVariant = const Color(0xFFF3F4F6); // Light gray

  // Card and border colors
  static Color cardBackground = const Color(0xFFFFFFFF);
  static Color borderColor = const Color(0xFFE5E7EB);
  static Color dividerColor = const Color(0xFFE5E7EB);
}

class AppDimensions {
  static double buttonHeight = 56;
  static double cardRadius = 16;
  static double containerRadius = 12;
  static double chipRadius = 24;

  // Spacing
  static double spacingXS = 4;
  static double spacingS = 8;
  static double spacingM = 16;
  static double spacingL = 24;
  static double spacingXL = 32;
  static double spacingXXL = 48;
}

class AppShadows {
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
}

ThemeData primaryTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: CardTheme(
    color: AppColors.cardBackground,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
    ),
  ),
  textTheme: TextTheme(
    // Display styles
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),

    // Headline styles
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),

    // Title styles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),

    // Body styles
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    ),

    // Label styles
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
  ),
);
