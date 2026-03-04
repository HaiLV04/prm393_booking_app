import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/constants/menu_colors.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key, this.onBackTap});

  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MenuColors.backgroundDark.withOpacity(0.95),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.white.withOpacity(0.06),
                ),
                child: IconButton(
                  onPressed: onBackTap,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: MenuColors.textLight,
                    size: 22,
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Our Menu',
                    style: TextStyle(
                      color: MenuColors.textLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: MenuColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              style: const TextStyle(color: MenuColors.textLight),
              decoration: InputDecoration(
                hintText: 'Search dishes, drinks, desserts...',
                hintStyle: const TextStyle(color: MenuColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: MenuColors.textMuted),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                filled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
