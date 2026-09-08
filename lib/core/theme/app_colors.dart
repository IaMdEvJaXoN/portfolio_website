import 'package:flutter/material.dart';

//Single source of truth for the palette.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF000000); // Vantablack
  static const Color surface = Color(0xFF0A0A0A); // cards/chips fill
  static const Color border = Color(0xFF262626); // default 1px border
  static const Color accent = Color(0xFF00E5FF); // cyber-blue
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF9E9E9E); // slate grey
}
