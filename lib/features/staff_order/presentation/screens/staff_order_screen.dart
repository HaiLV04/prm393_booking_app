import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_theme.dart';

class StaffOrderScreen extends StatefulWidget {
  const StaffOrderScreen({super.key});

  @override
  State<StaffOrderScreen> createState() => _StaffOrderScreenState();
}

class _StaffOrderScreenState extends State<StaffOrderScreen> {
  int _activeCategory = 0;

  final List<_OrderItem> _items = [
    _OrderItem(
      name: 'Goi ngo sen tom thit',
      price: 125000,
      quantity: 1,
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAMYMfmTM8DopTFL1s_NCP_jm7GVL8Z44wv-YfPU26xDh81dUAGM_CnZF_bbyCh7uJvs4aSsZAvDtZr858z6szIc3IjJMb2mre0nkyujfyudobB0P4GjbktDbg_jytFgj9Of9mr4KhpEo101QAlkWzkRJwEJD4mMmqgvVuThKHrfbUPT3jQMLgbz0SC3S1ENA3d3cx2MntxO_hlRdthzBNH8VOFIxPKgNuW2g_wg6OPNEG-zX7D7vr5i1l3Gqr6LwKXl4_WrszNG-I',
    ),
    _OrderItem(
      name: 'Nem ran Ha Noi',
      price: 95000,
      quantity: 0,
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBUmuFeFn-QDSF8OQwt_3OTBtMUv9zyYlJhDoTlOCcHm29n1MhR9I4gcc3nmit6v7GZDwpb1oYVJEu3gY44VVheaO_L2Gt7hDfMzziBHJemyblz1eWgOfN_51mPo_2cB5yyXYIvPqS6n0kbqYdtS8VoRib_l2-kVAtaExTeR4M1I4xbtSx_bBP7y_gQ5iMUYn6Hkq5tJhlnESYT326wY7ZqkaKXZ0gQOZWcIXnlZpRoK0JDsJaGswzAAY0To27GKamVChv6NXicvXI',
    ),
    _OrderItem(
      name: 'Bo bit tet sot tieu den',
      price: 285000,
      quantity: 2,
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDUCez-M5YN9_0Z9a1AbGDzRvzGAQ84cMJhbOfQA6MV03teBoR-PDpcyYQPbgVwNmSoJdba5tAxs0Un9y4YiJ2zyJhHU1yh4x-a6xRivvxu_mEhlCKO3zYNG9Vqep1BjZFaUqdLQt8eztTiIGAVJUS4RBo3ku4ZO2ti7aN1lkQkRbbQMdGwQ_H2tJozEM6MEPFjHItimn4Yl9ZdwWtUezUAN9N4uuuYlifbZPFkds8dYfdPRvOAeOG5NmlfZTBpcPRciJZAPwEwxSk',
    ),
    _OrderItem(
      name: 'Ca hoi ap chao',
      price: 320000,
      quantity: 0,
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCbQzDYFi_psaxdhYDJ440fg0LjjgljQgUzOS0THpK3_sWbq2cO5_4NnJe2l2PHkvkYMULXDgsGwPB5EIpMwIK0nJgiXAGrXaIVATrHbuGrGoHh0oD_QUCeLNaDYPUMFwvkV94a_R2RwUDy3DtfX3-g4vHC7PgYUeH3_ukvXEQh5hyBBrtptpUyOplSnzcQkmSM45ljdyc0d41Fn5cIH-uKuIf1d088zHQF63xMYxB7ylzsto9xdYXlDvPNWzE25n3vncDyNw4kV68',
    ),
  ];

  final List<String> _categories = [
    'Khai vi',
    'Mon chinh',
    'Do uong',
    'Trang mieng',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? StaffTheme.backgroundDark : StaffTheme.backgroundLight;
    final cardColor = isDark ? const Color(0xFF1A2E21) : Colors.white;
    final borderColor = StaffTheme.primary.withValues(alpha: 0.2);
    final mutedColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final cartItems = _items.where((item) => item.quantity > 0).toList();
    final totalQuantity = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalAmount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity * item.price);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 94),
                  child: Column(
                    children: [
                      _buildHeader(context, isDark),
                      _buildCategories(),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: _items.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.66,
                              ),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return _buildMenuCard(
                              item: item,
                              cardColor: cardColor,
                              borderColor: borderColor,
                              mutedColor: mutedColor,
                              onAdd: () => _changeQuantity(index, 1),
                              onRemove: () => _changeQuantity(index, -1),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCartBar(context, totalQuantity, totalAmount, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: StaffTheme.primary.withValues(alpha: 0.12)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Text(
              'Ban 01 • 3 khach',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final active = _activeCategory == index;
          return ChoiceChip(
            label: Text(
              _categories[index],
              style: GoogleFonts.inter(
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active
                    ? const Color(0xFF0F172A)
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            selected: active,
            selectedColor: StaffTheme.primary,
            backgroundColor: StaffTheme.primary.withValues(alpha: 0.12),
            side: BorderSide.none,
            onSelected: (_) => setState(() => _activeCategory = index),
          );
        },
        separatorBuilder: (context, _) => const SizedBox(width: 8),
        itemCount: _categories.length,
      ),
    );
  }

  Widget _buildMenuCard({
    required _OrderItem item,
    required Color cardColor,
    required Color borderColor,
    required Color mutedColor,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                image: DecorationImage(
                  image: NetworkImage(item.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0x99000000), Color(0x00000000)],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatVnd(item.price),
                  style: GoogleFonts.inter(fontSize: 12, color: mutedColor),
                ),
                const SizedBox(height: 8),
                if (item.quantity > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: StaffTheme.backgroundLight,
                    ),
                    child: Row(
                      children: [
                        _qtyButton(Icons.remove, onRemove),
                        SizedBox(
                          width: 24,
                          child: Text(
                            item.quantity.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                          ),
                        ),
                        _qtyButton(Icons.add, onAdd),
                      ],
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton.filledTonal(
                      style: IconButton.styleFrom(
                        backgroundColor: StaffTheme.primary.withValues(alpha: 0.15),
                        foregroundColor: StaffTheme.primary,
                      ),
                      onPressed: onAdd,
                      icon: const Icon(Icons.add),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: SizedBox(width: 24, height: 24, child: Icon(icon, size: 18)),
    );
  }

  Widget _buildCartBar(
    BuildContext context,
    int totalQuantity,
    int totalAmount,
    bool isDark,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF162A1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: StaffTheme.primary.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: StaffTheme.primary.withValues(alpha: 0.2),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.shopping_cart, color: StaffTheme.primary),
                  ),
                  if (totalQuantity > 0)
                    Positioned(
                      top: 1,
                      right: 1,
                      child: Container(
                        width: 18,
                        height: 18,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: StaffTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          totalQuantity.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tong cong',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    _formatVnd(totalAmount),
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: StaffTheme.primary,
                foregroundColor: const Color(0xFF0F172A),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              onPressed: totalQuantity == 0
                  ? null
                  : () => Navigator.pushNamed(context, '/staff/order-detail'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Xem Order'),
            ),
          ],
        ),
      ),
    );
  }

  void _changeQuantity(int index, int delta) {
    setState(() {
      final next = _items[index].quantity + delta;
      _items[index] = _items[index].copyWith(quantity: next < 0 ? 0 : next);
    });
  }

  String _formatVnd(int amount) {
    final raw = amount.toString();
    final buffer = StringBuffer();
    var count = 0;
    for (var i = raw.length - 1; i >= 0; i--) {
      buffer.write(raw[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return '${buffer.toString().split('').reversed.join()}d';
  }
}

class _OrderItem {
  const _OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  final String name;
  final int price;
  final int quantity;
  final String image;

  _OrderItem copyWith({
    String? name,
    int? price,
    int? quantity,
    String? image,
  }) {
    return _OrderItem(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }
}
