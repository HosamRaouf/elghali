import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: TextTheme(
        displayLarge: AppTypography.elMessiri.copyWith(color: AppColors.textLight, fontSize: 36),
        displayMedium: AppTypography.elMessiri.copyWith(color: AppColors.textLight, fontSize: 28),
        bodyLarge: AppTypography.cairo.copyWith(color: AppColors.textLight, fontSize: 16),
        bodyMedium: AppTypography.tajawal.copyWith(color: AppColors.secondary, fontSize: 14),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.background,
        onSecondary: AppColors.textLight,
        onSurface: AppColors.textLight,
        onError: AppColors.textLight,
      ),
    );
  }
}
