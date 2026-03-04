import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/constants/menu_colors.dart';

class PopularFeaturedCard extends StatelessWidget {
  const PopularFeaturedCard({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const ColoredBox(color: Color(0xFF263238));
              },
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                ),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: MenuColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Chef's Choice",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: MenuColors.backgroundDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Premium Ribeye Steak',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Served with truffle mashed potatoes',
                          style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 12),
                        ),
                      ),
                      Text(
                        r'$45.00',
                        style: TextStyle(
                          color: MenuColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
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
    );
  }
}
