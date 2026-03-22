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

  void _handleBack() {
    if (!mounted) {
      return;
    }

    FocusScope.of(context).unfocus();
    Navigator.pushNamedAndRemoveUntil(context, '/staff/home', (route) => false);
  }

  void _showOrderSentToast() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 18),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
        content: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1F2A23),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: StaffTheme.primary.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: StaffTheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_circle, color: StaffTheme.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Đã xác nhận món và gửi bếp thành công.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    messenger.hideCurrentSnackBar();
                    Navigator.pushNamed(
                      context,
                      '/staff/order-detail',
                      arguments: _context,
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB8FFD6),
                    textStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Xem đơn'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

      if (!mounted) {
        return;
      }

      if (_context == null) {
        setState(() {
          _error = 'Không tìm thấy order đang phục vụ.';
          _isLoading = false;
        });
        return;
      }

      final categories = await _repository.getCategories();
      final menuItems = await _repository.getMenuItems();
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

      if (!mounted) {
        return;
      }

      setState(() {
        _categories = categories;
        _activeCategoryId = null;
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
      if (!mounted) {
        return;
      }
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _changeCategory(int? categoryId) async {
    setState(() {
      _activeCategoryId = categoryId;
      _isLoading = true;
    });

    try {
      final menuItems = await _repository.getMenuItems(categoryId: categoryId);
      for (final item in menuItems) {
        _priceByMenuItemId[item.id] = item.price;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _menuItems = menuItems;
        _error = null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
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

  Future<void> _confirmAndSendToKitchen() async {
    if (_context == null || _isSubmitting) {
      return;
    }

    final pendingItems = <MapEntry<int, int>>[];
    for (final entry in _selectedQty.entries) {
      final currentSynced = _syncedQty[entry.key] ?? 0;
      final delta = entry.value - currentSynced;
      if (delta > 0) {
        pendingItems.add(MapEntry(entry.key, delta));
      }
    }

    if (pendingItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có món mới để xác nhận lên bếp.')),
      );
      return;
    }

    final pendingQty = pendingItems.fold<int>(0, (sum, e) => sum + e.value);
    final pendingAmount = pendingItems.fold<double>(0, (sum, e) {
      final unitPrice = _priceByMenuItemId[e.key] ?? 0;
      return sum + unitPrice * e.value;
    });

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận lên món'),
          content: Text(
            'Bạn sẽ gửi $pendingQty món mới xuống bếp '
            '(${_formatVnd(pendingAmount)}).\n\n'
            'Sau bước này vẫn có thể gọi thêm, và chỉ thanh toán khi khách ăn xong.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Xác nhận gửi bếp'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      for (final entry in pendingItems) {
        await _repository.addOrderItem(
          orderId: _context!.orderId,
          menuItemId: entry.key,
          quantity: entry.value,
        );
        final currentSynced = _syncedQty[entry.key] ?? 0;
        _syncedQty[entry.key] = currentSynced + entry.value;
      }

      if (!mounted) {
        return;
      }

      _showOrderSentToast();
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

    final totalAmount = _selectedQty.entries.fold<double>(0, (sum, entry) {
      final unitPrice = _priceByMenuItemId[entry.key] ?? 0;
      return sum + entry.value * unitPrice;
    });
    final pendingQty = _selectedQty.entries.fold<int>(0, (sum, entry) {
      final currentSynced = _syncedQty[entry.key] ?? 0;
      final delta = entry.value - currentSynced;
      return sum + (delta > 0 ? delta : 0);
    });
    final pendingAmount = _selectedQty.entries.fold<double>(0, (sum, entry) {
      final currentSynced = _syncedQty[entry.key] ?? 0;
      final delta = entry.value - currentSynced;
      if (delta <= 0) {
        return sum;
      }
      final unitPrice = _priceByMenuItemId[entry.key] ?? 0;
      return sum + delta * unitPrice;
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
                      _buildContextInfo(isDark),
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
                                : _menuItems.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'Không có món nào trong danh mục này.',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(color: mutedColor),
                                          ),
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Món mới chờ xác nhận', style: GoogleFonts.inter(fontSize: 12, color: mutedColor)),
                              Text(_formatVnd(pendingAmount), style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                              Text(
                                'Tổng tạm tính hiện tại: ${_formatVnd(totalAmount)}',
                                style: GoogleFonts.inter(fontSize: 11, color: mutedColor),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: StaffTheme.primary,
                            foregroundColor: const Color(0xFF0F172A),
                          ),
                          onPressed: pendingQty == 0 || _isSubmitting ? null : _confirmAndSendToKitchen,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.verified_outlined),
                          label: Text('Xác nhận lên món (${pendingQty.toString()})'),
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
        ? 'Gọi món'
        : '${_context!.tableName} - ${_context!.guestCount} khách';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: StaffTheme.primary.withValues(alpha: 0.12))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _handleBack,
            icon: const Icon(Icons.arrow_back),
          ),
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

  Widget _buildContextInfo(bool isDark) {
    final orderContext = _context;
    if (orderContext == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF172A20) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StaffTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: StaffTheme.primary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.table_restaurant, color: StaffTheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderContext.tableName, style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                Text(
                  '${orderContext.guestCount} khách - ${orderContext.customerName}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
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
          final isAllChip = index == 0;
          final category = isAllChip ? null : _categories[index - 1];
          final active = isAllChip ? _activeCategoryId == null : _activeCategoryId == category!.id;
          final label = isAllChip ? 'Tất cả' : category!.name;
          return ChoiceChip(
            label: Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? const Color(0xFF0F172A) : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            selected: active,
            selectedColor: StaffTheme.primary,
            backgroundColor: StaffTheme.primary.withValues(alpha: 0.12),
            side: BorderSide.none,
            onSelected: (_) => _changeCategory(category?.id),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: _categories.length + 1,
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
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: item.imageUrl.trim().isEmpty
                  ? _menuImagePlaceholder()
                  : Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => _menuImagePlaceholder(),
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

  Widget _menuImagePlaceholder() {
    return Container(
      color: StaffTheme.primary.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: const Icon(
        Icons.restaurant_menu,
        color: StaffTheme.primary,
        size: 32,
      ),
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
    return '${buffer.toString().split('').reversed.join()}đ';
  }
}
