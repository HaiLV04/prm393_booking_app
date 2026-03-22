import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';

class AdminDashboardStyles {
  static const Color background = AppColors.backgroundLight;
  static const Color card = AppColors.surfaceLight;
  static const Color primary = AppColors.primary;
  static Color borderColor = AppColors.primary.withOpacity(0.10);

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(12));

  static TextStyle headerTitle(BuildContext context) => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
  );

  static TextStyle smallMuted(BuildContext context) =>
      const TextStyle(fontSize: 12, color: AppColors.textSub);

  static TextStyle largeNumber(BuildContext context) => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textMain,
  );
}
