import 'package:flutter/material.dart';

class AdminDashboardStyles {
  // Colors
    static Color background(BuildContext context) => Theme.of(context).scaffoldBackgroundColor;
  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color backgroundDark = Color(0xFF102216);
  static const Color cardDark = Color(0xFF1A3322);
  static const Color primary = Color(0xFF13EC5B);
  static const Color primaryDark = Color(0xFF0EA341);

  // Radii
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(12));

  // Text styles
  static TextStyle headerTitle(BuildContext context) =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textPrimary(context));

  static TextStyle smallMuted(BuildContext context) =>
      TextStyle(fontSize: 12, color: _textSecondary(context));

  static TextStyle largeNumber(BuildContext context) =>
      TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _textPrimary(context));

  static Color _textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Color(0xFFE2E8F0) : Color(0xFF1E293B);

  static Color _textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Color(0xFF94A3B8) : Color(0xFF64748B);
}
