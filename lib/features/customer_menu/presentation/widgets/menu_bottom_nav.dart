import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/constants/menu_colors.dart';

class MenuBottomNav extends StatelessWidget {
  const MenuBottomNav({
    super.key,
    this.onHomeTap,
    this.onMenuTap,
    this.onBookTap,
    this.onCartTap,
  });

  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onBookTap;
  final VoidCallback? onCartTap;

  @override
  Widget build(BuildContext context) {
    Widget item({
      required String label,
      required IconData icon,
      required bool active,
      bool showDot = false,
      VoidCallback? onTap,
    }) {
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
                  Stack(
                    children: [
                      Icon(
                        icon,
                        color: active ? MenuColors.primary : MenuColors.textMuted,
                        size: 24,
                      ),
                      if (showDot)
                        const Positioned(
                          top: 1,
                          right: -1,
                          child: SizedBox(
                            width: 7,
                            height: 7,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: MenuColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: active ? MenuColors.primary : MenuColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: MenuColors.backgroundDark.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 26),
      child: Row(
        children: [
          item(
            label: 'Home',
            icon: Icons.home_filled,
            active: false,
            onTap: onHomeTap,
          ),
          item(
            label: 'Menu',
            icon: Icons.restaurant_menu,
            active: true,
            showDot: true,
            onTap: onMenuTap,
          ),
          item(
            label: 'Book',
            icon: Icons.calendar_month,
            active: false,
            onTap: onBookTap,
          ),
          item(
            label: 'Cart',
            icon: Icons.shopping_bag,
            active: false,
            onTap: onCartTap,
          ),
        ],
      ),
    );
  }
}
