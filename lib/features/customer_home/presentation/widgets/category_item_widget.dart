import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';
import 'package:prm393_booking_app/features/customer_home/data/home_models.dart';

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget({super.key, required this.item});

  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: item.active ? AppColors.primary : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(999),
            border: item.active
                ? Border.all(color: AppColors.surfaceLight, width: 4)
                : Border.all(color: const Color(0xFFF5F5F5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            item.icon,
            size: 30,
            color: item.active ? Colors.white : AppColors.textSub,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.name,
          style: TextStyle(
            color: item.active ? AppColors.textMain : AppColors.textSub,
            fontWeight: item.active ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
