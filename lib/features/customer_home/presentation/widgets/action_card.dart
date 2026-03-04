import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.filled,
  });

  final String title;
  final IconData icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: filled
                  ? Colors.white.withOpacity(0.2)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(icon, color: filled ? Colors.white : AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: filled ? Colors.white : AppColors.textMain,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
