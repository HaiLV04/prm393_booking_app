import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    this.onHomeTap,
    this.onMenuTap,
    this.onBookingsTap,
    this.onProfileTap,
  });

  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onBookingsTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 26),
      child: Row(
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_rounded,
            active: true,
            onTap: onHomeTap,
          ),
          _NavItem(
            label: 'Menu',
            icon: Icons.restaurant_menu_rounded,
            active: false,
            onTap: onMenuTap,
          ),
          _NavItem(
            label: 'Bookings',
            icon: Icons.calendar_month_rounded,
            active: false,
            onTap: onBookingsTap,
          ),
          _NavItem(
            label: 'Profile',
            icon: Icons.person_rounded,
            active: false,
            onTap: onProfileTap,
          ),
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
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
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
          ),
        ),
      ),
    );
  }
}
