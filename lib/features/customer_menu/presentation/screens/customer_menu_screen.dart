import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/customer_menu/data/menu_data.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/constants/menu_colors.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/widgets/menu_bottom_nav.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/widgets/menu_category_chips.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/widgets/menu_dish_grid_item.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/widgets/menu_header.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/widgets/popular_featured_card.dart';

class CustomerMenuScreen extends StatelessWidget {
  const CustomerMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MenuColors.backgroundDark,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 88),
                  child: CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _PinnedBoxDelegate(
                          minHeight: 116,
                          maxHeight: 116,
                          child: MenuHeader(
                            onBackTap: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _PinnedBoxDelegate(
                          minHeight: 52,
                          maxHeight: 52,
                          child: Container(
                            color: MenuColors.backgroundDark,
                            alignment: Alignment.centerLeft,
                            child: const MenuCategoryChips(categories: menuCategories),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'POPULAR NOW',
                                style: TextStyle(
                                  color: MenuColors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 10),
                              PopularFeaturedCard(imageUrl: popularImage),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                        sliver: SliverMainAxisGroup(
                          slivers: [
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'FULL MENU',
                                  style: TextStyle(
                                    color: MenuColors.textMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.72,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return MenuDishGridItem(dish: menuDishes[index]);
                                },
                                childCount: menuDishes.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MenuBottomNav(
                    onHomeTap: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    onMenuTap: () {},
                    onBookTap: () {
                      Navigator.pushReplacementNamed(context, '/book');
                    },
                    onCartTap: () {
                      Navigator.pushReplacementNamed(context, '/cart');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinnedBoxDelegate extends SliverPersistentHeaderDelegate {
  _PinnedBoxDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedBoxDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        child != oldDelegate.child;
  }
}
