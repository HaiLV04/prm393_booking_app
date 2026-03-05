import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/common/presentation/widgets/customer_bottom_nav.dart';

class CustomerCartScreen extends StatelessWidget {
  const CustomerCartScreen({super.key});

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _lightBackground = Color(0xFFF6F8F6);
  static const Color _darkBackground = Color(0xFF102216);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _darkBackground : _lightBackground;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 360),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                '/home',
                              ),
                              icon: const Icon(Icons.arrow_back),
                            ),
                            Expanded(
                              child: Text(
                                'Your Cart',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
                          children: [
                            _cartItem(
                              cardColor: cardColor,
                              name: 'Truffle Burger',
                              price: r'$24.00',
                              image:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBY6pA9jD7tXLqugxpp0a4mycZBvFrZqZA3nD8d3BFwgmBjqTWMzXBqIIMYIYVkF4lfYOzr9afYsBLMZVSQi1PzqK9t3UQfSWEMvJe2fLAFeigO6VzcVyH6_xK0mLnkWtnJGJiSHynfkRaVKcmRDktBkjl4iPBXhR_JkhcMmWP-t8HjjNwkHVmWs4DNYFv_bgyldDiZNN-zuYCOZQygydEK4FeUUlh8daPN2Ki5wDtsGQsga_bGA5rnsOoidOEtc-xWM26x_TltDQ',
                              quantity: '1',
                            ),
                            const SizedBox(height: 10),
                            _cartItem(
                              cardColor: cardColor,
                              name: 'Sweet Potato Fries',
                              price: r'$16.00',
                              image:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuChVVYw1AK7btYjWTEN9nRRi8rtlimivn50829PufyXikMpsuskd2O_EtZ6HYq_A8zjO0fP1yu1iRncxEN5dcIypkn7p24cKR_OFGXM_QKgSAnmJyUkWH53KiuJuGQTYUHW_MPxVLClcoRoETVp3u4lGTuHS81A5lko23zCDegYEYL41iR-gJqzJyoAE6CH8wwwrB1pzR2EeDHpvGi5G_OlVIhWvN7uXLeGhkbM5WwAyZmgiIOoeEAY8XVZhhWhSCWO74Qfl16uFw',
                              quantity: '2',
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton.icon(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/menu',
                                ),
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: _primary,
                                ),
                                label: Text(
                                  'Add more items',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: _primary,
                                    fontWeight: FontWeight.w600,
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
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 84,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _primary.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                          child: Column(
                            children: [
                              _sumRow('Subtotal', r'$40.00'),
                              const SizedBox(height: 8),
                              _sumRow('Taxes & Fees', r'$4.20'),
                              const Divider(height: 28),
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _primary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.receipt_long,
                                      color: _primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Total',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    r'$44.20',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Text('Checkout'),
                                  label: const Icon(Icons.arrow_forward),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: const CustomerBottomNav(
                    activeTab: CustomerNavTab.cart,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cartItem({
    required Color cardColor,
    required String name,
    required String price,
    required String image,
    required String quantity,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.plusJakartaSans(
                    color: _primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _smallButton('-'),
              const SizedBox(width: 8),
              Text(
                quantity,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              _smallButton('+', primary: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallButton(String text, {bool primary = false}) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primary
            ? _primary.withValues(alpha: 0.12)
            : const Color(0xFFF1F5F9),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: primary ? _primary : const Color(0xFF475569),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _sumRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B)),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B)),
        ),
      ],
    );
  }
}
