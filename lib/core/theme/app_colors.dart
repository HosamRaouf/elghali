import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFC9A84C);
  static const Color secondary = Color(0xFF8C7B6E);
  static const Color background = Color(0xFF0D0500);
  static const Color textLight = Color(0xFFF5EDD6);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  
  static const Color cardBackground = Color(0x0AFFFFFF); // rgba(255,255,255,0.04)
  static const Color cardBorder = Color(0x1AC9A84C); // rgba(201,168,76,0.1)
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC9A84C),
      Color(0xFFB5682A),
    ],
  );
}
