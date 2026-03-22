import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system - moved to top level
class StaffTypography {
  // Display
  static TextStyle displayMedium(bool isDark) => GoogleFonts.sora(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.2,
    color: isDark ? StaffDesignSystem.textPrimaryDark : StaffDesignSystem.textPrimary,
  );

  // Headline
  static TextStyle headlineMedium(bool isDark) => GoogleFonts.sora(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: isDark ? StaffDesignSystem.textPrimaryDark : StaffDesignSystem.textPrimary,
  );

  static TextStyle headlineSmall(bool isDark) => GoogleFonts.sora(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: isDark ? StaffDesignSystem.textPrimaryDark : StaffDesignSystem.textPrimary,
  );

  // Title
  static TextStyle titleLarge(bool isDark) => GoogleFonts.sora(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: isDark ? StaffDesignSystem.textPrimaryDark : StaffDesignSystem.textPrimary,
  );

  static TextStyle titleMedium(bool isDark) => GoogleFonts.sora(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: isDark ? StaffDesignSystem.textPrimaryDark : StaffDesignSystem.textPrimary,
  );

  static TextStyle titleSmall(bool isDark) => GoogleFonts.sora(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: isDark ? StaffDesignSystem.textPrimaryDark : StaffDesignSystem.textPrimary,
  );

  // Body
  static TextStyle bodyLarge(bool isDark) => GoogleFonts.sora(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: isDark ? StaffDesignSystem.textSecondaryDark : StaffDesignSystem.textSecondary,
  );

  static TextStyle bodyMedium(bool isDark) => GoogleFonts.sora(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: isDark ? StaffDesignSystem.textSecondaryDark : StaffDesignSystem.textSecondary,
  );

  static TextStyle bodySmall(bool isDark) => GoogleFonts.sora(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: isDark ? StaffDesignSystem.textLightDark : StaffDesignSystem.textLight,
  );

  // Label
  static TextStyle labelLarge(bool isDark) => GoogleFonts.sora(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0.5,
    color: isDark ? StaffDesignSystem.textPrimaryDark : StaffDesignSystem.textPrimary,
  );

  static TextStyle labelMedium(bool isDark) => GoogleFonts.sora(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0.5,
    color: isDark ? StaffDesignSystem.textSecondaryDark : StaffDesignSystem.textSecondary,
  );

  static TextStyle labelSmall(bool isDark) => GoogleFonts.sora(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
    color: isDark ? StaffDesignSystem.textLightDark : StaffDesignSystem.textLight,
  );
}

/// Staff App Design System with Material Design 3 principles
class StaffDesignSystem {
  // Primary colors
  static const Color primary = Color(0xFF0FAF87);
  static const Color primaryDark = Color(0xFF0A7F64);
  static const Color primaryLight = Color(0xFF58D9B8);

  // Semantic colors
  static const Color success = Color(0xFF0FAF87);
  static const Color warning = Color(0xFFFFA500);
  static const Color error = Color(0xFFE85D5D);
  static const Color info = Color(0xFF2F7EF7);

  // Background colors
  static const Color bgLight = Color(0xFFEEF3F8);
  static const Color bgDark = Color(0xFF0F1613);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1A2F20);

  // Surface colors
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF212121);
  static const Color overlayDark = Color(0xFF0F1613);

  // Border & divider
  static const Color borderLight = Color(0xFFD9E3EF);
  static const Color borderDark = Color(0xFF334155);

  // Text colors
  static const Color textPrimary = Color(0xFF122230);
  static const Color textSecondary = Color(0xFF4D5F72);
  static const Color textLight = Color(0xFF708397);

  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textLightDark = Color(0xFF9CA3AF);

  // Status colors
  static const Color statusPending = Color(0xFFFCD34D);
  static const Color statusConfirmed = Color(0xFF60A5FA);
  static const Color statusServing = Color(0xFF0FAF87);
  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFFF87171);

  static const Color statusOccupied = Color(0xFFEF4444);
  static const Color statusAvailable = Color(0xFF0FAF87);
  static const Color statusReserved = Color(0xFF3B82F6);
  static const Color statusUnavailable = Color(0xFF9CA3AF);

  // Shadows
  static const List<BoxShadow> shadowLight = [
    BoxShadow(
      color: Color(0x140E2942),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x1B0E2942),
      blurRadius: 22,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x220E2942),
      blurRadius: 28,
      offset: Offset(0, 12),
    ),
  ];

  // Radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 20;

  // Spacing
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  // Opacity values
  static const double opacityDisabled = 0.38;
  static const double opacityHover = 0.08;
  static const double opacityFocus = 0.12;
  static const double opacityPressed = 0.12;

  // Transitions
  static const Duration transitionFast = Duration(milliseconds: 150);
  static const Duration transitionNormal = Duration(milliseconds: 300);
  static const Duration transitionSlow = Duration(milliseconds: 500);

  /// Get color based on order status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return statusPending;
      case 'confirmed':
        return statusConfirmed;
      case 'serving':
        return statusServing;
      case 'completed':
        return statusCompleted;
      case 'cancelled':
        return statusCancelled;
      default:
        return info;
    }
  }

  /// Get color based on table status
  static Color getTableStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'occupied':
        return statusOccupied;
      case 'available':
        return statusAvailable;
      case 'reserved':
        return statusReserved;
      case 'unavailable':
        return statusUnavailable;
      default:
        return borderLight;
    }
  }

  /// Get label text for status
  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Đang chờ';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'serving':
        return 'Đang phục vụ';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }
}

/// Context helper extension for theme
extension ThemeContextHelper on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get backgroundColor =>
      isDarkMode ? StaffDesignSystem.bgDark : StaffDesignSystem.bgLight;

  Color get cardColor =>
      isDarkMode ? StaffDesignSystem.cardDark : StaffDesignSystem.cardLight;

  Color get borderColor =>
      isDarkMode ? StaffDesignSystem.borderDark : StaffDesignSystem.borderLight;

  Color get textPrimary =>
      isDarkMode ? StaffDesignSystem.textPrimaryDark : StaffDesignSystem.textPrimary;

  Color get textSecondary =>
      isDarkMode ? StaffDesignSystem.textSecondaryDark : StaffDesignSystem.textSecondary;

  Color get textTertiary =>
      isDarkMode ? StaffDesignSystem.textLightDark : StaffDesignSystem.textLight;
}
