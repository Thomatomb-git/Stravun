import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Backgrounds
  static const Color backgroundPrimary = Color(0xFF25252C); // Obsidian
  static const Color backgroundSurface = Color(0xFF19191D); // Ink

  // Accent & Utilities
  static const Color accentNeon = Color(0xFFB7FF00); // Volt
  static const Color borderMuted = Color(0xFF3A3A42);
  static const Color error = Color(0xFFFF4C4C);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A8);

  // Mission Tiers
  static const Color tierBronze = Color(0xFFCD7F32);
  static const Color tierSilver = Color(0xFFC0C0C0);
  static const Color tierGold = Color(0xFFFFD700);

  // Additional Material Token equivalents (from DESIGN.md)
  static const Color surfaceDim = Color(0xFF121319);
  static const Color surfaceBright = Color(0xFF38393F);
  static const Color outline = Color(0xFF8C9479);
  static const Color primaryContainer = Color(0xFFB2F800);
  static const Color onPrimaryContainer = Color(0xFF4D6E00);
}

class AppTextStyles {
  static final TextStyle displayStat = GoogleFonts.outfit(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: -0.02 * 48, // -0.02em
    color: AppColors.textPrimary,
  );

  static final TextStyle headlineLg = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    color: AppColors.textPrimary,
  );

  static final TextStyle headlineMd = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textPrimary,
  );

  static final TextStyle labelMd = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.01 * 14,
    color: AppColors.textPrimary,
  );

  static final TextStyle labelSm = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.textPrimary,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      cardColor: AppColors.backgroundSurface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentNeon,
        surface: AppColors.backgroundSurface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundSurface,
        selectedItemColor: AppColors.accentNeon,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderMuted, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderMuted, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentNeon, width: 1),
        ),
        labelStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentNeon,
          foregroundColor: AppColors.backgroundPrimary, // Text color
          textStyle: AppTextStyles.labelMd,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayStat,
        headlineLarge: AppTextStyles.headlineLg,
        headlineMedium: AppTextStyles.headlineMd,
        bodyLarge: AppTextStyles.bodyLg,
        bodyMedium: AppTextStyles.bodyMd,
        labelLarge: AppTextStyles.labelMd,
        labelSmall: AppTextStyles.labelSm,
      ),
    );
  }
}
