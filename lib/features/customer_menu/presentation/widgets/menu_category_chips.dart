import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/customer_menu/data/menu_models.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/constants/menu_colors.dart';

class MenuCategoryChips extends StatelessWidget {
  const MenuCategoryChips({super.key, required this.categories});

  final List<MenuCategory> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16, right: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = categories[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: item.active ? MenuColors.primary : MenuColors.surfaceDark,
              borderRadius: BorderRadius.circular(999),
              border: item.active
                  ? null
                  : Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Text(
              item.name,
              style: TextStyle(
                color: item.active ? MenuColors.backgroundDark : MenuColors.textLight,
                fontSize: 13,
                fontWeight: item.active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: categories.length,
      ),
    );
  }
}
