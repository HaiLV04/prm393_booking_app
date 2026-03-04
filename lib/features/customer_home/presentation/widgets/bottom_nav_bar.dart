import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 26),
      child: Row(
        children: const [
          _NavItem(label: 'Home', icon: Icons.home_rounded, active: true),
          _NavItem(
            label: 'Menu',
            icon: Icons.restaurant_menu_rounded,
            active: false,
          ),
          _NavItem(
            label: 'Bookings',
            icon: Icons.calendar_month_rounded,
            active: false,
          ),
          _NavItem(label: 'Profile', icon: Icons.person_rounded, active: false),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
  });

  final String label;
  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active ? AppColors.primary : AppColors.textSub,
            size: active ? 28 : 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? AppColors.primary : AppColors.textSub,
            ),
          ),
        ],
      ),
    );
  }
}
