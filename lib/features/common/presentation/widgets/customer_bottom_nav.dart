import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomerNavTab { home, menu, bookings, cart, profile }

class CustomerBottomNav extends StatelessWidget {
  const CustomerBottomNav({
    super.key,
    required this.activeTab,
    this.cartBadgeCount,
  });

  final CustomerNavTab activeTab;
  final int? cartBadgeCount;

  static const Color _active = Color(0xFFF46A25);
  static const Color _inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      height: 84,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 14),
      decoration: BoxDecoration(
        color: background,
        border: Border(
          top: BorderSide(color: _inactive.withValues(alpha: 0.24)),
        ),
      ),
      child: Row(
        children: [
          _item(context, CustomerNavTab.home, Icons.home, 'Home'),
          _item(context, CustomerNavTab.menu, Icons.restaurant, 'Menu'),
          _item(
            context,
            CustomerNavTab.bookings,
            Icons.calendar_month,
            'Bookings',
          ),
          _item(
            context,
            CustomerNavTab.cart,
            Icons.shopping_cart,
            'Cart',
            badgeCount: cartBadgeCount,
          ),
          _item(context, CustomerNavTab.profile, Icons.person, 'Profile'),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    CustomerNavTab tab,
    IconData icon,
    String label, {
    int? badgeCount,
  }) {
    final isActive = activeTab == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTap(context, tab),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: isActive ? _active : _inactive, size: 24),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: _active,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: isActive ? _active : _inactive,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, CustomerNavTab tab) {
    if (tab == activeTab) return;

    switch (tab) {
      case CustomerNavTab.home:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case CustomerNavTab.menu:
        Navigator.pushReplacementNamed(context, '/menu');
        break;
      case CustomerNavTab.bookings:
        Navigator.pushReplacementNamed(context, '/my-bookings');
        break;
      case CustomerNavTab.cart:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case CustomerNavTab.profile:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
}
