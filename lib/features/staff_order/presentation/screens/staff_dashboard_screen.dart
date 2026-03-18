import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_theme.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? StaffTheme.backgroundDark
        : StaffTheme.backgroundLight;
    final cardColor = isDark ? StaffTheme.cardDark : Colors.white;
    final borderColor = isDark
        ? StaffTheme.borderDark
        : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                _buildHeader(cardColor, borderColor, titleColor, mutedColor),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    children: [
                      _buildStatCard(cardColor, borderColor, titleColor, mutedColor),
                      const SizedBox(height: 20),
                      _buildQuickActions(context, cardColor, borderColor, titleColor),
                      const SizedBox(height: 20),
                      _buildLatestNotices(
                        context,
                        cardColor,
                        borderColor,
                        titleColor,
                        mutedColor,
                      ),
                    ],
                  ),
                ),
                _buildBottomNav(context, cardColor, borderColor, mutedColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    Color cardColor,
    Color borderColor,
    Color titleColor,
    Color mutedColor,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: StaffTheme.primary.withValues(alpha: 0.3), width: 2),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuA3vV_5hrD5CfgwpPg5Wmc744VhrTKNJWfculJI-k--9AwK7peL0sBL16Kb_cLQhH3lD4Dle4ArlAGS_ZZcXsiLcsEsVuPmO1NuQFLmJJIQlR8hU3rZUvEIpwdNn-zaOozMcnOISc1ifIWInk8DbpjcW44G__MSBVPMYOQvfzfs8Ke9R9YlIX5yS0a8OtEfPPEwKN4kvIo_uuPbl1M2wPKCD8GWfoS8kn5a7U_ORZrWpVgZaOJmGYCJ30XMnTejmiY_ISYhw02peTY',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nhan vien',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: mutedColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'Chao buoi toi, Nguyen An',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: borderColor),
            ),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.notifications_none_rounded)),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: StaffTheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    Color cardColor,
    Color borderColor,
    Color titleColor,
    Color mutedColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: StaffTheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'TINH TRANG HIEN TAI',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: StaffTheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Hom nay: 12 ban da dat | 5 ban dang phuc vu',
            style: GoogleFonts.inter(
              fontSize: 20,
              height: 1.3,
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.68,
              minHeight: 8,
              backgroundColor: borderColor,
              color: StaffTheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cong suat: 68%',
                style: GoogleFonts.inter(fontSize: 13, color: mutedColor),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: StaffTheme.primary,
                  foregroundColor: StaffTheme.backgroundDark,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onPressed: () {},
                child: const Text('Chi tiet'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    Color cardColor,
    Color borderColor,
    Color titleColor,
  ) {
    final actions = [
      (icon: Icons.table_restaurant, label: 'So do ban', onTap: () {}),
      (icon: Icons.event_available, label: 'Dat cho moi', onTap: () {}),
      (
        icon: Icons.restaurant_menu,
        label: 'Thuc don',
        onTap: () => Navigator.pushNamed(context, '/staff/order'),
      ),
      (icon: Icons.bar_chart, label: 'Thong ke', onTap: () {}),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loi tat nhanh',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: titleColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: actions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: action.onTap,
              child: Ink(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: StaffTheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Icon(action.icon, color: StaffTheme.primary),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      action.label,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLatestNotices(
    BuildContext context,
    Color cardColor,
    Color borderColor,
    Color titleColor,
    Color mutedColor,
  ) {
    final notices = [
      (
        icon: Icons.flatware,
        color: const Color(0xFFF97316),
        title: 'Ban 04 vua dat mon',
        subtitle: '2 phut truoc • 4 mon moi',
        unread: true,
      ),
      (
        icon: Icons.payments,
        color: StaffTheme.primary,
        title: 'Yeu cau thanh toan Ban 01',
        subtitle: '15 phut truoc • Tong: 1.250k',
        unread: false,
      ),
      (
        icon: Icons.person_add_alt,
        color: const Color(0xFF3B82F6),
        title: 'Khach moi tai Ban 12',
        subtitle: '25 phut truoc • 2 khach',
        unread: false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thong bao moi nhat',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: titleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Xem tat ca')),
          ],
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < notices.length; i++) ...[
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (i == 0) {
                Navigator.pushNamed(context, '/staff/order-detail');
              }
            },
            child: Ink(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: notices[i].color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(notices[i].icon, color: notices[i].color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notices[i].title,
                          style: GoogleFonts.inter(
                            color: titleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          notices[i].subtitle,
                          style: GoogleFonts.inter(
                            color: mutedColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: notices[i].unread
                          ? StaffTheme.primary
                          : borderColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i != notices.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildBottomNav(
    BuildContext context,
    Color cardColor,
    Color borderColor,
    Color mutedColor,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.table_restaurant, 'Ban', true, () {}),
          _navItem(Icons.book_online, 'Dat cho', false, () {}),
          _navItem(
            Icons.restaurant,
            'Thuc don',
            false,
            () => Navigator.pushNamed(context, '/staff/order'),
          ),
          _navItem(Icons.person_outline, 'Ca nhan', false, () {}),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? StaffTheme.primary : const Color(0xFF94A3B8)),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: active ? StaffTheme.primary : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
