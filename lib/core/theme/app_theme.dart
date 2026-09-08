import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  //Single radius constant enforces "tight, sharp, functional" geometry everywhere.
  static const double radius = 3.0;
  static const Duration motionDuration = Duration(milliseconds: 300);
  static const Curve motionCurve = Curves.fastOutSlowIn;

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.background,
      primary: AppColors.accent,
      secondary: AppColors.accent,
    ),
    textTheme: AppTypography.textTheme,
    splashFactory: NoSplash.splashFactory, // no material ripple glow
    highlightColor: Colors.transparent,
    dividerColor: AppColors.border,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        side: const BorderSide(color: AppColors.border),
        foregroundColor: AppColors.textPrimary,
      ),
    ),
  );
}
