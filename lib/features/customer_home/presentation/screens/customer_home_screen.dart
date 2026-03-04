import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/common/presentation/widgets/customer_bottom_nav.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  static const Color _primary = Color(0xFFFF7043);
  static const Color _lightBackground = Color(0xFFFDF8F6);
  static const Color _darkBackground = Color(0xFF1A0D0A);

  final _searchController = TextEditingController();

  final _categories = const [
    (label: 'Pizza', icon: Icons.local_pizza),
    (label: 'Burgers', icon: Icons.lunch_dining),
    (label: 'Pasta', icon: Icons.ramen_dining),
    (label: 'Drinks', icon: Icons.local_cafe),
    (label: 'Desserts', icon: Icons.icecream),
  ];

  final _popularItems = const [
    (
      name: 'Margherita Margherita',
      rating: '4.8',
      reviews: '(124)',
      price: r'$14.99',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAE7LLalgAoYInb4wI_dOPWGs2zERcJkRkLToSauS7BK_kJoDD08_ka21FrCz-THS_AC-FELM-YRunK0tk-9XAVDb5uoR3oGURk9sUCr5f6ALjXIwrXiEXVm349WDHXo5C8CFc6U1laxDevp5TeimHuEDOZYm5_MSddmjh3nm3sR7zcQxBMYScGQd4NBZ3n8u2f0sh9tvJc4JGyMe72M0BCtI7bfiEH8v6eCGIsZP6PXAhLBc9VVXTPK5D3cOConhCPdVOFcG76WA',
      isFavorite: false,
      badge: null,
    ),
    (
      name: 'Classic Smash Burger',
      rating: '4.9',
      reviews: '(89)',
      price: r'$12.50',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC1Dw7c9_E5QluUCp-G7DEQGouolmy8yNvX9IzuWmE4QSdUFNhvciILlTKqGl4FmWC-1F4_ek2iGg81ClfaMjYmbGIUx8q8eGLBdf1GCxlr42ZevcxYpKBYFV9ppPMcNx1CJ4Ewk2lrRAkZpCX9gV1QXRLu45P0GX80QCTvhCm1Ph-e3fCXFs1JCVKigwOrYbmvU3C05aUYByqbyAk0y6rVz-pz1g2PwdvuIEKLj8OqQmX78mCQjPMpQeBWdR2NOFQdhJ_daNAT0Q',
      isFavorite: true,
      badge: null,
    ),
    (
      name: 'Summer Lemonade',
      rating: '4.5',
      reviews: '(42)',
      price: r'$4.99',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCoaL_dIc6I9JFx7_ReIHI8kASFnlddD6aw6kaQeNcsOaWzMSgXI10rgCkRDk0rcYD_CVxm4H0H0eT7OrODlx9FBot3tezrUS36-kJs80MEIJUqOECvEXIZigQ8uNFy6u-IzoPSgWMyXOd9Y1Qe9ugN3sOPNdAhXPuNVcXrmv8tGDjA6a3cMTlAyuGeWb4fWxZ-4BkkYv0MVWFSi3Gtn_Pknh7g2d15_7WpDbilonVFzRTvbgRipKF5QHmJHdG4m55eafL4JeiH4A',
      isFavorite: false,
      badge: 'NEW',
    ),
    (
      name: 'Truffle Pasta',
      rating: '4.7',
      reviews: '(156)',
      price: r'$18.50',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCOjVzK0bHK_P0uDxTYlVGGwmfpuDZVUPhJpf6DPP15evHUXtfrLBdJqJSqb2HV2iZq6sfMCiXyc2OkEOWwz358qOlocclFd8nDhkKe7L2zsnO_iqz4SJ930a2C420Yx0wHDMaUxjl7xU4t1gaNLhdyxS5WxOlBtx-2HNSDb00s6vFEgddt306UX5Bbn-EQAOsV0tcvXH8Nd5Y6IVUu8NfGUrk8Ej2tRlUjDZ0aD8MmSgBisFV3npUhWyyPtl74-h_xGFeM-W0Mmw',
      isFavorite: false,
      badge: null,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _darkBackground : _lightBackground;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final secondary = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

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
                  padding: const EdgeInsets.only(bottom: 92),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: _primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.menu, color: _primary),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Delivering to',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: secondary,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Home',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.expand_more,
                                        color: _primary,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: _primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.shopping_cart,
                                      color: _primary,
                                    ),
                                    onPressed: () =>
                                        Navigator.pushNamed(context, '/cart'),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: _primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '2',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: secondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        'Search for dishes, categories...',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      color: secondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 170,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildPromoCard(
                              title: 'Weekend Special!',
                              subtitle: '20% off all large pizzas',
                              cta: 'Order Now',
                              image:
                                  'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=400&q=80',
                              dark: false,
                            ),
                            const SizedBox(width: 12),
                            _buildPromoCard(
                              title: 'Family Feast',
                              subtitle: 'Save \$10 on combo meals',
                              cta: 'View Deal',
                              image:
                                  'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=400&q=80',
                              dark: true,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: [
                            Text(
                              'Categories',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'See All',
                              style: GoogleFonts.plusJakartaSans(
                                color: _primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          itemBuilder: (context, index) {
                            final item = _categories[index];
                            return Column(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    color: _primary,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.label,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 14),
                          itemCount: _categories.length,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            Text(
                              'Popular Now',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            _arrowButton(
                              Icons.arrow_back_ios_new,
                              isPrimary: false,
                            ),
                            const SizedBox(width: 8),
                            _arrowButton(
                              Icons.arrow_forward_ios,
                              isPrimary: true,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        child: GridView.builder(
                          itemCount: _popularItems.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.68,
                              ),
                          itemBuilder: (context, index) {
                            final item = _popularItems[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: borderColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(14),
                                              ),
                                          child: Image.network(
                                            item.image,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        if (item.badge != null)
                                          Positioned(
                                            left: 8,
                                            top: 8,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                item.badge!,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        Positioned(
                                          right: 8,
                                          top: 8,
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white
                                                .withValues(alpha: 0.85),
                                            child: Icon(
                                              Icons.favorite,
                                              size: 16,
                                              color: item.isFavorite
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.rating,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.reviews,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 12,
                                                    color: secondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              item.price,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: _primary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              width: 28,
                                              height: 28,
                                              decoration: const BoxDecoration(
                                                color: _primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: const CustomerBottomNav(
                    activeTab: CustomerNavTab.home,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard({
    required String title,
    required String subtitle,
    required String cta,
    required String image,
    required bool dark,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: dark
            ? null
            : const LinearGradient(
                colors: [Color(0xFFFF7043), Color(0xFFEA580C)],
              ),
        color: dark ? const Color(0xFF1F2937) : null,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Opacity(
                  opacity: 0.28,
                  child: Image.network(image, width: 120, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: dark
                        ? _primary.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dark ? 'COMBO DEAL' : 'LIMITED OFFER',
                    style: GoogleFonts.plusJakartaSans(
                      color: dark ? _primary : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.05,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: dark ? _primary : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    cta,
                    style: GoogleFonts.plusJakartaSans(
                      color: dark ? Colors.white : _primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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

  Widget _arrowButton(IconData icon, {required bool isPrimary}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isPrimary
            ? _primary.withValues(alpha: 0.12)
            : const Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 16,
        color: isPrimary ? _primary : const Color(0xFF64748B),
      ),
    );
  }
}
