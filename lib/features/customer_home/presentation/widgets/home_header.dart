import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 260;
          final isUltraCompact = constraints.maxWidth < 190;

          return Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu_rounded, size: 24),
                color: AppColors.textMain,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 34, height: 34),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Gourmet Haven',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCompact ? 16 : 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                  ),
                ),
              ),
              if (!isUltraCompact) ...[
                Container(
                  width: isCompact ? 34 : 40,
                  height: isCompact ? 34 : 40,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primary,
                    size: isCompact ? 20 : 24,
                  ),
                ),
              ],
              if (!isCompact) ...[
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuATuLlHMR4XxABPrPICBx85JtR8Inl5XQHFOdeiq1aMgSvzX1dH3XVWIxQ4bXotrkRrR3EGX7jyriN2SjjejO2Iwh4RahX10xDgqwCcJycX7w7j_mRdUGpskYHGvTeiKuf0cx-t526fsqgdNNnOdJXzsjemy1kA0rcG2w6YKZ7w6FAxgM7r-KMmXPBxDgBLunlaO7hAcsk_cXpzb94L4nW8lnK7cTuyMOnoh7QgdjpvywYRGtmdDmX-VurQDAm4_63HBjhSFD7lWus',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const ColoredBox(color: Color(0xFFE0E0E0));
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
