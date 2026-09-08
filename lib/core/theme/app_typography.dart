import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

//Inter for UI text,JetBrains Mono for tech/code accents(mantra,
//tech-stack chips,code blocks in case studies).
class AppTypography {
  AppTypography._();

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 50,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      height: 1.03,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      color: AppColors.textSecondary,
      height: 1.5,
    ),
  );

  static TextStyle get mono => GoogleFonts.jetBrainsMono(
    fontSize: 15,
    color: AppColors.accent,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get monoSmall =>
      GoogleFonts.jetBrainsMono(fontSize: 12, color: AppColors.textSecondary);
}
