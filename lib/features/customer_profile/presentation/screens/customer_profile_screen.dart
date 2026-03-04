import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/common/presentation/widgets/customer_bottom_nav.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  static const Color _primary = Color(0xFFF46A25);
  static const Color _lightBackground = Color(0xFFF8F6F5);
  static const Color _darkBackground = Color(0xFF221610);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _darkBackground : _lightBackground;
    final cardColor = isDark ? const Color(0xFF2C1D15) : Colors.white;
    final muted = isDark ? const Color(0xFFB89D8F) : const Color(0xFF846C60);

    return Scaffold(
      backgroundColor: bgColor,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  color: cardColor,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/home'),
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Expanded(
                        child: Text(
                          'Profile',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 8),
                    children: [
                      Container(
                        color: cardColor,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                        child: Column(
                          children: [
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDy9dSkYAfrmQqfyQGz-skQ3goHFZkNEb4AGJwUQwAp8fxuSxihpQqGFiJNGEND-AuQ9z98lBVrMKg-ftMmoafra1UNZMlTzhkMMIt898BV_vvAIYyj5YOTx6hLTWoiiMXWK27sXtFCzqbUbADivV4HNn7fQbBcg7xYt7OOlOedxOSsmQdL51IG_moNF4CE5M8osIZYt991neJf9DQYUTCVwXQbICh10y-vZqzsas3bfVqzuI15orW297AMMbMgJQEyC6OEos8_2Q',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Alex Morgan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF3D291E)
                                    : const Color(0xFFF0EDEA),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'alex.morgan@example.com',
                                style: GoogleFonts.plusJakartaSans(
                                  color: muted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                              ),
                              child: const Text('Edit Profile'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 22, 16, 6),
                        child: Text(
                          'ACCOUNT',
                          style: GoogleFonts.plusJakartaSans(
                            color: muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                      _menuTile(
                        cardColor: cardColor,
                        icon: Icons.history,
                        title: 'Order History',
                        subtitle: 'View past orders and receipts',
                        iconColor: _primary,
                      ),
                      _menuTile(
                        cardColor: cardColor,
                        icon: Icons.credit_card,
                        title: 'Payment Methods',
                        subtitle: 'Manage cards and wallets',
                        iconColor: _primary,
                      ),
                      _menuTile(
                        cardColor: cardColor,
                        icon: Icons.location_on,
                        title: 'Addresses',
                        subtitle: 'Delivery locations',
                        iconColor: _primary,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
                        child: Text(
                          'SETTINGS',
                          style: GoogleFonts.plusJakartaSans(
                            color: muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                      _menuTile(
                        cardColor: cardColor,
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: null,
                        iconColor: muted,
                      ),
                      _menuTile(
                        cardColor: cardColor,
                        icon: Icons.logout,
                        title: 'Log Out',
                        subtitle: null,
                        iconColor: Colors.red,
                        danger: true,
                        onTap: () => _handleLogout(context),
                      ),
                    ],
                  ),
                ),
                const CustomerBottomNav(activeTab: CustomerNavTab.profile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuTile({
    required Color cardColor,
    required IconData icon,
    required String title,
    required String? subtitle,
    required Color iconColor,
    bool danger = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          color: danger ? Colors.red : null,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: const Color(0xFF846C60),
                          ),
                        ),
                    ],
                  ),
                ),
                if (!danger) const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Do you want to log out and return to Login?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}
