import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_theme.dart';

class StaffOrderScreen extends StatefulWidget {
  const StaffOrderScreen({super.key});

  @override
  State<StaffOrderScreen> createState() => _StaffOrderScreenState();
}

class _StaffOrderScreenState extends State<StaffOrderScreen> {
  final StaffOrderRepository _repository = StaffOrderRepository();

  StaffOrderContext? _context;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;

  List<CategoryData> _categories = <CategoryData>[];
  List<MenuItemData> _menuItems = <MenuItemData>[];
  final Map<int, int> _selectedQty = <int, int>{};
  final Map<int, int> _syncedQty = <int, int>{};
  final Map<int, double> _priceByMenuItemId = <int, double>{};

  int? _activeCategoryId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _initialize();
    }
  }

  Future<void> _initialize() async {
    try {
      final routeContext = ModalRoute.of(context)?.settings.arguments;
      _context = routeContext is StaffOrderContext
          ? routeContext
          : await _repository.getActiveContext();

      if (_context == null) {
        setState(() {
          _error = 'Khong tim thay order dang phuc vu.';
          _isLoading = false;
        });
        return;
      }

      final categories = await _repository.getCategories();
      final activeCategoryId = categories.isNotEmpty ? categories.first.id : null;
      final menuItems = await _repository.getMenuItems(categoryId: activeCategoryId);
      final items = await _repository.getOrderItems(_context!.orderId);

      final synced = <int, int>{
        for (final item in items) item.menuItemId: item.quantity,
      };
      for (final item in items) {
        _priceByMenuItemId[item.menuItemId] = item.unitPrice;
      }
      for (final item in menuItems) {
        _priceByMenuItemId[item.id] = item.price;
      }

      setState(() {
        _categories = categories;
        _activeCategoryId = activeCategoryId;
        _menuItems = menuItems;
        _syncedQty
          ..clear()
          ..addAll(synced);
        _selectedQty
          ..clear()
          ..addAll(synced);
        _error = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _changeCategory(int categoryId) async {
    setState(() {
      _activeCategoryId = categoryId;
      _isLoading = true;
    });

    try {
      final menuItems = await _repository.getMenuItems(categoryId: categoryId);
      for (final item in menuItems) {
        _priceByMenuItemId[item.id] = item.price;
      }
      setState(() {
        _menuItems = menuItems;
        _error = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _changeQuantity(int menuItemId, int delta) {
    final current = _selectedQty[menuItemId] ?? 0;
    final synced = _syncedQty[menuItemId] ?? 0;
    final next = current + delta;
    setState(() {
      // Backend currently supports adding quantity only, so do not allow going below synced.
      _selectedQty[menuItemId] = next < synced ? synced : next;
    });
  }

  Future<void> _submitAndOpenOrder() async {
    if (_context == null || _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      for (final entry in _selectedQty.entries) {
        final currentSynced = _syncedQty[entry.key] ?? 0;
        final delta = entry.value - currentSynced;
        if (delta > 0) {
          await _repository.addOrderItem(
            orderId: _context!.orderId,
            menuItemId: entry.key,
            quantity: delta,
          );
          _syncedQty[entry.key] = entry.value;
        }
      }

      if (!mounted) {
        return;
      }

      await Navigator.pushNamed(
        context,
        '/staff/order-detail',
        arguments: _context,
      );

      // Reload after returning from detail screen.
      setState(() {
        _isLoading = true;
        _error = null;
      });
      await _initialize();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? StaffTheme.backgroundDark : StaffTheme.backgroundLight;
    final cardColor = isDark ? const Color(0xFF1A2E21) : Colors.white;
    final borderColor = StaffTheme.primary.withValues(alpha: 0.2);
    final mutedColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final totalQty = _selectedQty.values.fold<int>(0, (sum, qty) => sum + qty);
    final totalAmount = _selectedQty.entries.fold<double>(0, (sum, entry) {
      final unitPrice = _priceByMenuItemId[entry.key] ?? 0;
      return sum + entry.value * unitPrice;
    });

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
                      _buildHeader(isDark),
                      _buildCategories(),
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _error != null
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(_error!, textAlign: TextAlign.center),
                                    ),
                                  )
                                : GridView.builder(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                    itemCount: _menuItems.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.66,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = _menuItems[index];
                                      final qty = _selectedQty[item.id] ?? 0;
                                      return _menuCard(
                                        item: item,
                                        quantity: qty,
                                        cardColor: cardColor,
                                        borderColor: borderColor,
                                        mutedColor: mutedColor,
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF162A1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: StaffTheme.primary.withValues(alpha: 0.25)),
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
                          child: const Center(child: Icon(Icons.shopping_cart, color: StaffTheme.primary)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tong cong', style: GoogleFonts.inter(fontSize: 12, color: mutedColor)),
                              Text(_formatVnd(totalAmount), style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: StaffTheme.primary,
                            foregroundColor: const Color(0xFF0F172A),
                          ),
                          onPressed: totalQty == 0 || _isSubmitting ? null : _submitAndOpenOrder,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.arrow_forward),
                          label: const Text('Xem Order'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final title = _context == null
        ? 'Order Screen'
        : '${_context!.tableName} - ${_context!.guestCount} khach';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: StaffTheme.primary.withValues(alpha: 0.12))),
      ),
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(onPressed: _initialize, icon: const Icon(Icons.refresh)),
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
          final category = _categories[index];
          final active = _activeCategoryId == category.id;
          return ChoiceChip(
            label: Text(
              category.name,
              style: GoogleFonts.inter(
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? const Color(0xFF0F172A) : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            selected: active,
            selectedColor: StaffTheme.primary,
            backgroundColor: StaffTheme.primary.withValues(alpha: 0.12),
            side: BorderSide.none,
            onSelected: (_) => _changeCategory(category.id),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: _categories.length,
      ),
    );
  }

  Widget _menuCard({
    required MenuItemData item,
    required int quantity,
    required Color cardColor,
    required Color borderColor,
    required Color mutedColor,
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
                  image: NetworkImage(item.imageUrl.isNotEmpty ? item.imageUrl : 'https://picsum.photos/300/300'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(_formatVnd(item.price), style: GoogleFonts.inter(fontSize: 12, color: mutedColor)),
                const SizedBox(height: 8),
                if (quantity > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: StaffTheme.backgroundLight,
                    ),
                    child: Row(
                      children: [
                        _qtyButton(Icons.remove, () => _changeQuantity(item.id, -1)),
                        SizedBox(
                          width: 24,
                          child: Text(quantity.toString(), textAlign: TextAlign.center, style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                        ),
                        _qtyButton(Icons.add, () => _changeQuantity(item.id, 1)),
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
                      onPressed: () => _changeQuantity(item.id, 1),
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

  String _formatVnd(num amount) {
    final rounded = amount.round().toString();
    final buffer = StringBuffer();
    var count = 0;
    for (var i = rounded.length - 1; i >= 0; i--) {
      buffer.write(rounded[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return '${buffer.toString().split('').reversed.join()}d';
  }
}
