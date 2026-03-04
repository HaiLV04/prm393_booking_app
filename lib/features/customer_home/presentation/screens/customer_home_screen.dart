import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';
import 'package:prm393_booking_app/features/customer_home/data/home_data.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/widgets/action_card.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/widgets/bottom_nav_bar.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/widgets/category_item_widget.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/widgets/featured_dish_card.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/widgets/home_header.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/widgets/home_hero_section.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 92),
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(child: HomeHeader()),
                      const SliverToBoxAdapter(child: HomeHeroSection()),
                      SliverToBoxAdapter(child: _buildQuickActions()),
                      SliverToBoxAdapter(child: _buildCategories(context)),
                      SliverToBoxAdapter(child: _buildFeaturedDishes(context)),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ActionCard(
              title: 'Book a Table',
              icon: Icons.table_restaurant,
              filled: true,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ActionCard(
              title: 'Delivery',
              icon: Icons.local_shipping,
              filled: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 22),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('View all')),
              ],
            ),
          ),
          SizedBox(
            height: 106,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return CategoryItemWidget(item: categories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedDishes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Dishes',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          ...featuredDishes.map(
            (dish) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FeaturedDishCard(dish: dish),
            ),
          ),
        ],
      ),
    );
  }
}
