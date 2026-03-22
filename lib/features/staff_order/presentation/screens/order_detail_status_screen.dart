import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/widgets/staff_widgets.dart';

class OrderDetailStatusScreen extends StatefulWidget {
  const OrderDetailStatusScreen({super.key});

  @override
  State<OrderDetailStatusScreen> createState() => _OrderDetailStatusScreenState();
}

class _OrderDetailStatusScreenState extends State<OrderDetailStatusScreen> {
  final StaffOrderRepository _repository = StaffOrderRepository();
  late Future<_OrderDetailVm> _future;
  StaffOrderContext? _context;
  String _paymentMethod = 'cash';
  bool _mealCompletedConfirmed = false;
  Timer? _refreshTimer;

  static const List<_PaymentMethodOption> _paymentMethods = <_PaymentMethodOption>[
    _PaymentMethodOption(value: 'cash', label: 'Tiền mặt'),
    _PaymentMethodOption(value: 'card', label: 'Thẻ'),
    _PaymentMethodOption(value: 'qr_transfer', label: 'Chuyển khoản QR'),
  ];

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _future = _load();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = _load();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<_OrderDetailVm> _load() async {
    final arg = ModalRoute.of(context)?.settings.arguments;
    _context = arg is StaffOrderContext ? arg : await _repository.getActiveContext();
    if (_context == null) {
      throw Exception('Không tìm thấy order đang phục vụ.');
    }

    final order = await _repository.getOrder(_context!.orderId);
    final items = await _repository.getOrderItems(_context!.orderId);
    return _OrderDetailVm(order: order, items: items, context: _context!);
  }

  Future<void> _checkout({required int orderId, required double taxAmount}) async {
    final reservationStatus = (_context?.reservationStatus ?? '').trim().toLowerCase();
    final isReservationClosed = reservationStatus == 'cancelled' || reservationStatus == 'canceled';
    if (isReservationClosed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn đã hủy, không thể thanh toán.')),
      );
      return;
    }

    if (!_mealCompletedConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng xác nhận khách đã ăn xong trước khi thanh toán.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận hoàn tất bữa ăn'),
          content: Text(
            'Bạn muốn thanh toán đơn #$orderId bằng ${_paymentMethodLabel(_paymentMethod)}?\n\n'
            'Sau khi xác nhận, bữa ăn sẽ được kết thúc.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _repository.checkout(
        orderId: orderId,
        paymentMethod: _paymentMethod,
        taxAmount: taxAmount,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thanh toán thành công.')),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/staff/home', (route) => false);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: FutureBuilder<_OrderDetailVm>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              final errorText = snapshot.error.toString();
              final isNoActiveOrder = errorText.contains('Không tìm thấy order đang phục vụ');
              return EmptyState(
                icon: Icons.error_outline,
                title: 'Không tải được chi tiết đơn hàng',
                description: errorText,
                actionLabel: isNoActiveOrder ? 'Về trang staff' : 'Thử lại',
                onAction: () {
                  if (isNoActiveOrder) {
                    Navigator.pushNamedAndRemoveUntil(context, '/staff/home', (route) => false);
                    return;
                  }
                  setState(() {
                    _future = _load();
                  });
                },
              );
            }

            final vm = snapshot.data!;
            final statusNormalized = vm.order.status.trim().toLowerCase();
            final reservationStatus = (vm.context.reservationStatus ?? '').trim().toLowerCase();
            final isCancelledReservation = reservationStatus == 'cancelled' || reservationStatus == 'canceled';
            final isCompletedOrder =
              statusNormalized == 'completed' || statusNormalized == 'checkedout' || statusNormalized == 'finished';
            final isClosedOrder = isCompletedOrder || isCancelledReservation || statusNormalized == 'cancelled' || statusNormalized == 'canceled';
            final vat = vm.order.totalAmount * 0.08;
            final grandTotal = vm.order.invoiceFinalTotal ?? (vm.order.totalAmount + vat);
            final itemCount = vm.items.fold<int>(0, (sum, item) => sum + item.quantity);

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        border: Border(bottom: BorderSide(color: context.borderColor)),
                      ),
                      child: Row(
                        children: [
                          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                          Expanded(
                            child: Text(
                              vm.context.tableName,
                              textAlign: TextAlign.center,
                              style: StaffTypography.titleLarge(isDark),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _future = _load();
                              });
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: context.borderColor),
                              boxShadow: StaffDesignSystem.shadowLight,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: StaffDesignSystem.primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.group, color: StaffDesignSystem.primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${vm.context.guestCount} khách - ${_timeOfDay(vm.context.checkInTime)}',
                                    style: StaffTypography.titleSmall(isDark),
                                  ),
                                ),
                                StatusBadge(
                                  status: isCancelledReservation
                                      ? 'cancelled'
                                      : isCompletedOrder
                                          ? 'completed'
                                          : 'serving',
                                  isSmall: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          SectionHeader(title: 'Chi tiết món gọi'),
                          const SizedBox(height: 10),
                          if (vm.items.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: context.borderColor),
                              ),
                              child: Text(
                                'Chưa có món nào trong đơn.',
                                style: StaffTypography.bodyMedium(isDark),
                              ),
                            )
                          else
                            for (final item in vm.items)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: context.cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: context.borderColor),
                                    boxShadow: StaffDesignSystem.shadowLight,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: StaffDesignSystem.primary.withValues(alpha: 0.12),
                                        ),
                                        child: const Icon(Icons.fastfood, color: StaffDesignSystem.primary),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(item.menuItemName, style: StaffTypography.titleMedium(isDark)),
                                                ),
                                                Text(_formatVnd(item.unitPrice), style: StaffTypography.titleSmall(isDark)),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            Text('Số lượng: ${item.quantity}', style: StaffTypography.bodySmall(isDark)),
                                            const SizedBox(height: 6),
                                            _itemStatusChip(item.itemStatus, isDark),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: Text(
                              vm.order.note.isEmpty ? 'Không có ghi chú cho bếp.' : vm.order.note,
                              style: StaffTypography.bodyMedium(isDark),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(border: Border(top: BorderSide(color: context.borderColor))),
                            child: Column(
                              children: [
                                _summaryRow('Tổng tiền món ($itemCount)', _formatVnd(vm.order.totalAmount), context.textSecondary, isDark),
                                _summaryRow('Thuế VAT (8%)', _formatVnd(vat), context.textSecondary, isDark),
                                if (vm.order.invoicePaidAt != null)
                                  _summaryRow(
                                    'Đã thanh toán lúc',
                                    _formatDateTime(vm.order.invoicePaidAt!),
                                    context.textSecondary,
                                    isDark,
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Thành tiền', style: StaffTypography.titleLarge(isDark)),
                                    Text(
                                      _formatVnd(grandTotal),
                                      style: StaffTypography.headlineSmall(isDark).copyWith(color: StaffDesignSystem.primaryDark),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (isClosedOrder)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isCancelledReservation
                                          ? const Color(0xFFFDECEC)
                                          : const Color(0xFFEAF9F1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isCancelledReservation
                                            ? const Color(0xFFF5B2B2)
                                            : const Color(0xFF9FD8BC),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isCancelledReservation
                                              ? 'Đơn đã hủy, không thể gọi thêm món hoặc thanh toán.'
                                              : 'Đơn đã thanh toán và hoàn tất.',
                                          style: StaffTypography.titleSmall(isDark),
                                        ),
                                        if ((vm.order.invoicePaymentMethod ?? '').isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Phương thức: ${_paymentMethodLabel(vm.order.invoicePaymentMethod!)}',
                                              style: StaffTypography.bodySmall(isDark),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                else ...[
                                  DropdownButtonFormField<String>(
                                    initialValue: _paymentMethod,
                                    decoration: InputDecoration(
                                      labelText: 'Phương thức thanh toán',
                                      labelStyle: StaffTypography.bodySmall(isDark),
                                      filled: true,
                                      fillColor: context.cardColor,
                                    ),
                                    items: _paymentMethods
                                        .map(
                                          (method) => DropdownMenuItem<String>(
                                            value: method.value,
                                            child: Text(method.label),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      if (value == null) {
                                        return;
                                      }
                                      setState(() {
                                        _paymentMethod = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF6E8),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFF4C88B)),
                                    ),
                                    child: CheckboxListTile(
                                      value: _mealCompletedConfirmed,
                                      onChanged: (value) {
                                        setState(() {
                                          _mealCompletedConfirmed = value ?? false;
                                        });
                                      },
                                      title: const Text('Xác nhận khách đã ăn xong'),
                                      subtitle: const Text(
                                        'Chỉ bật mục này khi khách không gọi thêm món và sẵn sàng thanh toán.',
                                      ),
                                      controlAffinity: ListTileControlAffinity.leading,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: StaffDesignSystem.primary, width: 1.5),
                                            foregroundColor: StaffDesignSystem.primaryDark,
                                            padding: const EdgeInsets.symmetric(vertical: 13),
                                          ),
                                          onPressed: () => Navigator.pushNamed(context, '/staff/order', arguments: vm.context),
                                          icon: const Icon(Icons.add_circle_outline),
                                          label: const Text('Gọi thêm món'),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: FilledButton.icon(
                                          style: FilledButton.styleFrom(
                                            backgroundColor: StaffDesignSystem.primary,
                                            foregroundColor: const Color(0xFF102216),
                                            padding: const EdgeInsets.symmetric(vertical: 13),
                                          ),
                                          onPressed: _mealCompletedConfirmed
                                              ? () => _checkout(orderId: vm.order.id, taxAmount: vat)
                                              : null,
                                          icon: const Icon(Icons.payments),
                                          label: const Text('Thanh toán & hoàn tất bữa ăn'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _itemStatusChip(String status, bool isDark) {
    final normalized = status.toLowerCase();
    Color bg;
    Color fg;
    String label;

    if (normalized == 'pending') {
      bg = const Color(0xFFFFF6E8);
      fg = const Color(0xFFB56A00);
      label = 'Chờ bếp';
    } else if (normalized == 'preparing') {
      bg = const Color(0xFFE8F3FF);
      fg = const Color(0xFF1D4ED8);
      label = 'Đang chế biến';
    } else if (normalized == 'served') {
      bg = const Color(0xFFEAF9F1);
      fg = const Color(0xFF0E9F6E);
      label = 'Đã lên món';
    } else {
      bg = const Color(0xFFF2F4F7);
      fg = const Color(0xFF667085);
      label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: StaffTypography.labelSmall(isDark).copyWith(color: fg)),
    );
  }

  Widget _summaryRow(String label, String value, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: StaffTypography.bodySmall(isDark).copyWith(color: color)),
          Text(value, style: StaffTypography.bodySmall(isDark).copyWith(color: color)),
        ],
      ),
    );
  }

  String _paymentMethodLabel(String value) {
    for (final method in _paymentMethods) {
      if (method.value == value) {
        return method.label;
      }
    }
    return value;
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

  String _timeOfDay(DateTime dateTime) {
    final h = dateTime.hour.toString().padLeft(2, '0');
    final m = dateTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year;
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}

class _PaymentMethodOption {
  const _PaymentMethodOption({required this.value, required this.label});

  final String value;
  final String label;
}

class _OrderDetailVm {
  const _OrderDetailVm({
    required this.order,
    required this.items,
    required this.context,
  });

  final OrderData order;
  final List<OrderItemData> items;
  final StaffOrderContext context;
}
