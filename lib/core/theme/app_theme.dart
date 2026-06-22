import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xCC232629);
  static const surfaceElevated = Color(0xFF1E1E1E);
  static const primary = Color(0xFFC8FF00);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9E9E9E);
  static const textMuted = Color(0xFF6E6E6E);
  static const divider = Color(0xFF2A2A2A);
  static const cardBackground = Color(0xFF1A1A1A);
  static const chipBackground = Color(0xFF232629);
  static const userBubble = Color(0x3BC2DF00);
  static const aiBubble = Color(0xFF1E1E1E);
  static const bottomNav = Color(0xFF0F0F0F);
  static const inputBackground = Color(0xFF1A1A1A);
  static const badge = Color(0xFF252525);
  static const borderColor = Color(0xFF414548);
  static const askAiGradientStart = Color(0xFFE4FF2A);
  static const askAiGradientEnd = Color(0xFFA3B948);
}

class AppTheme {
  static ThemeData get dark {
    final manrope = GoogleFonts.manrope().fontFamily;
    final base = ThemeData(brightness: Brightness.dark, fontFamily: manrope);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.primary,
        onPrimary: Colors.black,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: manrope,
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.bottomNav,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontFamily: manrope,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(fontFamily: manrope, fontSize: 10),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
