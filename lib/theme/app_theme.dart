import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    );

    final textTheme = GoogleFonts.soraTextTheme(base.textTheme).copyWith(
      headlineLarge: const TextStyle(
        fontSize: 34,
        height: 1.1,
        fontWeight: FontWeight.w800,
        color: Color(0xFF122230),
      ),
      headlineMedium: const TextStyle(
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w800,
        color: Color(0xFF122230),
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF122230),
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: Color(0xFF4C5C6D),
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        color: Color(0xFF6E7D8D),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFEEF3F8),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: const Color(0xFF0FAF87),
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0xFF163148).withValues(alpha: 0.12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        labelStyle: GoogleFonts.sora(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textMain,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE7EDF0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE7EDF0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0FAF87)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  const AppTheme._();
}
