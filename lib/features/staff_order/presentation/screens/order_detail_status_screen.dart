import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_theme.dart';

class OrderDetailStatusScreen extends StatelessWidget {
  const OrderDetailStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? StaffTheme.backgroundDark : StaffTheme.backgroundLight;
    final card = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final muted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: border)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Text(
                          'Ban 01',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0x1F94A3B8) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: StaffTheme.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.group, color: StaffTheme.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '3 khach • 19:30',
                                style: GoogleFonts.inter(
                                  color: titleColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'Dang phuc vu',
                              style: GoogleFonts.inter(fontSize: 12, color: muted),
                            ),
                            const SizedBox(width: 6),
                            const SizedBox(
                              width: 10,
                              height: 10,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: StaffTheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Chi tiet mon goi',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildItem(
                        card: card,
                        border: border,
                        titleColor: titleColor,
                        muted: muted,
                        name: 'Pho bo tai nam',
                        price: '50.000d',
                        quantity: 1,
                        image:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCA9_noxoZrp6DoJkBsXyEuEpGezwo7MycqDNrXtU76pCpw1hZcdFSGYx7Ryj6ljvucV9JzJju-q2372aH7jxxtGD9xAAyw0uAaVDObBVYbOk4BMi0eO1CMLK70qE_7-HerMEbC2rFLc3AlM39x0uSm_DYJCURjvHyxMMwzUKpBInLlbJTjL03VQbJezDfizMqzrcRLFva3WNj7QfgMDbQ_gSk7Wg05mDBejpK_heu-pO8pTwtVYo86qWgwKLavxGyWN7lYqHusTwU',
                        statusLabel: 'Cho bep',
                        statusColor: const Color(0xFFF59E0B),
                        statusIcon: Icons.schedule,
                      ),
                      const SizedBox(height: 8),
                      _buildItem(
                        card: card,
                        border: border,
                        titleColor: titleColor,
                        muted: muted,
                        name: 'Bun cha Ha Noi',
                        price: '90.000d',
                        quantity: 2,
                        image:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuD1PcsOwB0ighmBAs7WwVo0Wz7trtYKieo2b36g4_Noi5JZP9vFk4BKlOezFOD6jzuuBQBjsRpRkMKjnCvs2QqTfGpgP22Aa9LJYFJauLrSKa6KxOGPZ5E29_YSY7vnBlUPOBT3HRuCYkGpu5VogNkW0jECl2F0us0kQRW53anmhhC6xxfNRXpA1sNIvWHqtHG119r8MkJB1WK3BT1ysFDhxHax7w5SfgumDR1ls2I8CF9RHHAerhD8rjQHu5oKNY-LNZEnuo-RNd8',
                        statusLabel: 'Dang che bien',
                        statusColor: const Color(0xFF3B82F6),
                        statusIcon: Icons.soup_kitchen,
                      ),
                      const SizedBox(height: 8),
                      _buildItem(
                        card: card,
                        border: border,
                        titleColor: titleColor,
                        muted: muted,
                        name: 'Tra da',
                        price: '15.000d',
                        quantity: 3,
                        image:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDIElMiJhthBTvOuRozLz0IFpQi_R9l-HU_mFxfQY77sJZ31CIijlOSy9Yh3RVeFjpDLFoEa8ZRxGt8Nl2rOh6986pUki8lr22UHnNC9nl6MLwRQn4WQN2zAJJtvz15IGb74se6zWj15dNc--8oT7t0tHHLlr8EvAF-7u_R7VwAFl9GY7yZ54QT_tixTHnWjSTwWNEThV6J215vzKcUH5Wz1TYGRF_b-T1Nf5KI_i9x9m2wrQ6QePGlDfkByvaHwdtrGhKPSdKu6Rw',
                        statusLabel: 'Da len mon',
                        statusColor: const Color(0xFF22C55E),
                        statusIcon: Icons.check_circle,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0x1F94A3B8) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.edit_note, size: 18, color: muted),
                                const SizedBox(width: 6),
                                Text(
                                  'Ghi chu cho bep:',
                                  style: GoogleFonts.inter(
                                    color: titleColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Pho khong hanh, bun cha nhieu nuoc cham.',
                              style: GoogleFonts.inter(color: muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: border)),
                        ),
                        child: Column(
                          children: [
                            _summaryRow('Tong tien mon (6)', '155.000d', muted),
                            _summaryRow('Thue VAT (8%)', '12.400d', muted),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Thanh tien',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: titleColor,
                                  ),
                                ),
                                Text(
                                  '167.400d',
                                  style: GoogleFonts.inter(
                                    fontSize: 21,
                                    color: StaffTheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: StaffTheme.primary, width: 2),
                                      foregroundColor: StaffTheme.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 13),
                                    ),
                                    onPressed: () => Navigator.pushNamed(context, '/staff/order'),
                                    icon: const Icon(Icons.add_circle),
                                    label: const Text('Goi them mon'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FilledButton.icon(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: StaffTheme.primary,
                                      foregroundColor: StaffTheme.backgroundDark,
                                      padding: const EdgeInsets.symmetric(vertical: 13),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Da gui yeu cau thanh toan')),
                                      );
                                    },
                                    icon: const Icon(Icons.payments),
                                    label: const Text('Thanh toan'),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  Widget _buildItem({
    required Color card,
    required Color border,
    required Color titleColor,
    required Color muted,
    required String name,
    required String price,
    required int quantity,
    required String image,
    required String statusLabel,
    required Color statusColor,
    required IconData statusIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image,
              width: 78,
              height: 78,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'So luong: $quantity',
                  style: GoogleFonts.inter(color: muted),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 5),
                      Text(
                        statusLabel,
                        style: GoogleFonts.inter(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: color, fontSize: 13)),
          Text(value, style: GoogleFonts.inter(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}
