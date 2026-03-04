import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 190,
                width: double.infinity,
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAa9ABSzhN9BUyAnX4JHGe3_OmNrNDtHTpp2HrJUpY7Vl7IiH79env4hLlrrAE3tyfDkAVplRMSUrETFemlWZirkiiyp7N385fF5bbaQI-RyoaYh2biRHsjthBWk8ZCSmglqfYYCSDuBcfKrbK2AbZQ4XGHTN40IyF0BAJXooWgZb0XXEQfCMtQ0cDYt8SvaeRBrWaeEkz2KkdpoDMTQiAFlMsSSU3v9B9nV2RO0C13ML9f37Zd-GCcPbGIcL7qaHydB_aFAeATkvA',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const ColoredBox(color: Color(0xFFE0E0E0));
                  },
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    "Today's Special",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Grilled Salmon Feast',
                            style: TextStyle(
                              color: AppColors.textMain,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'With asparagus and lemon butter sauce',
                            style: TextStyle(
                              color: AppColors.textSub,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          r'$18.50',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          r'$37.00',
                          style: TextStyle(
                            color: AppColors.textSub,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Order Now - 50% Off'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
}
