import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageProfileScreen extends StatelessWidget {
  const ManageProfileScreen({super.key});

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _lightBackground = Color(0xFFF6F8F6);
  static const Color _darkBackground = Color(0xFF102216);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _darkBackground : _lightBackground;
    final cardColor = isDark ? const Color(0xFF1A2F20) : Colors.white;
    final muted = isDark ? const Color(0xFF9DB9A6) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Tai khoan',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? const Color(0xFF1A2F20)
                                      : const Color(0xFFE8F8ED),
                                  border: Border.all(color: _primary, width: 4),
                                ),
                                child: Center(
                                  child: Text(
                                    'NA',
                                    style: GoogleFonts.inter(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      color: _primary,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: _primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: bgColor, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color(0xFF102216),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Nguyen Van An',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'an.nguyen@restaurant.com',
                            style: GoogleFonts.inter(
                              color: muted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'STAFF',
                              style: GoogleFonts.inter(
                                color: _primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _menuCard(
                        context,
                        cardColor: cardColor,
                        icon: Icons.key,
                        iconColor: _primary,
                        title: 'Doi mat khau',
                        subtitle: 'Bao mat tai khoan',
                      ),
                      const SizedBox(height: 10),
                      _menuCard(
                        context,
                        cardColor: cardColor,
                        icon: Icons.notifications,
                        iconColor: _primary,
                        title: 'Thong bao',
                        subtitle: 'Cap nhat he thong',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '3',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.chevron_right, color: muted),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _menuCard(
                        context,
                        cardColor: cardColor.withValues(alpha: 0.6),
                        icon: Icons.settings,
                        iconColor: Colors.grey,
                        title: 'Cai dat',
                        subtitle: 'Chi danh cho quan tri vien',
                        enabled: false,
                        trailing: const Icon(Icons.lock, color: Colors.grey),
                      ),
                      const SizedBox(height: 18),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.logout, color: Colors.red),
                                const SizedBox(width: 8),
                                Text(
                                  'Dang xuat',
                                  style: GoogleFonts.inter(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required Color cardColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    bool enabled = true,
  }) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF9DB9A6)
        : const Color(0xFF64748B);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        enabled: enabled,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(color: muted, fontSize: 12),
        ),
        trailing: trailing ?? Icon(Icons.chevron_right, color: muted),
        onTap: enabled ? () {} : null,
      ),
    );
  }
}
