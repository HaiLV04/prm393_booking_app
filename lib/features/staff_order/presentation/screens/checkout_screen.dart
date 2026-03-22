import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/widgets/staff_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedPaymentMethod;
  bool _isProcessing = false;

  final List<Map<String, String>> _paymentMethods = const [
    {'id': 'cash', 'label': 'Tiền mặt'},
    {'id': 'card', 'label': 'Thẻ ngân hàng'},
    {'id': 'qr_transfer', 'label': 'Chuyển khoản QR'},
  ];

  // Mock order data - can be replaced by API source.
  final double _orderTotal = 450000;
  final List<Map<String, dynamic>> _orderItems = const [
    {'name': 'Cơm mực', 'quantity': 2, 'unitPrice': 150000, 'total': 300000},
    {'name': 'Nước ép cam', 'quantity': 2, 'unitPrice': 45000, 'total': 90000},
    {'name': 'Kem tiramisu', 'quantity': 1, 'unitPrice': 60000, 'total': 60000},
  ];

  Future<void> _handleCheckout() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn phương thức thanh toán')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận thanh toán'),
          content: Text('Bạn muốn thanh toán bằng ${_paymentLabel(_selectedPaymentMethod!)}?'),
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

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thanh toán thành công qua ${_paymentLabel(_selectedPaymentMethod!)}')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Align(
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
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Text(
                          'Thanh toán',
                          textAlign: TextAlign.center,
                          style: StaffTypography.titleLarge(isDark),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(StaffDesignSystem.spacing16),
                    children: [
                      SectionHeader(title: 'Tóm tắt đơn hàng'),
                      const SizedBox(height: StaffDesignSystem.spacing12),
                      Container(
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: context.borderColor),
                          boxShadow: StaffDesignSystem.shadowLight,
                        ),
                        child: Column(
                          children: _orderItems.map((item) {
                            return ListTile(
                              title: Text(item['name'].toString(), style: StaffTypography.titleSmall(isDark)),
                              subtitle: Text(
                                '${item['quantity']} x ${_formatVnd(item['unitPrice'] as num)}',
                                style: StaffTypography.bodySmall(isDark),
                              ),
                              trailing: Text(
                                _formatVnd(item['total'] as num),
                                style: StaffTypography.titleSmall(isDark),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: StaffDesignSystem.spacing16),
                      Container(
                        padding: const EdgeInsets.all(StaffDesignSystem.spacing16),
                        decoration: BoxDecoration(
                          color: StaffDesignSystem.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: StaffDesignSystem.primary.withValues(alpha: 0.45)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tổng cộng', style: StaffTypography.titleMedium(isDark)),
                            Text(
                              _formatVnd(_orderTotal),
                              style: StaffTypography.headlineSmall(isDark).copyWith(color: StaffDesignSystem.primaryDark),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: StaffDesignSystem.spacing24),
                      SectionHeader(title: 'Phương thức thanh toán'),
                      const SizedBox(height: StaffDesignSystem.spacing12),
                      ..._paymentMethods.map((method) {
                        final id = method['id']!;
                        final selected = _selectedPaymentMethod == id;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: StaffDesignSystem.spacing12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => setState(() => _selectedPaymentMethod = id),
                            child: Container(
                              padding: const EdgeInsets.all(StaffDesignSystem.spacing16),
                              decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected ? StaffDesignSystem.primary : context.borderColor,
                                  width: selected ? 2 : 1,
                                ),
                                boxShadow: StaffDesignSystem.shadowLight,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                    color: selected ? StaffDesignSystem.primary : context.textSecondary,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(method['label']!, style: StaffTypography.bodyMedium(isDark)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    border: Border(top: BorderSide(color: context.borderColor)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: StaffDesignSystem.primary,
                        foregroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isProcessing ? null : _handleCheckout,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.payments_outlined),
                      label: Text(_isProcessing ? 'Đang xử lý...' : 'Xác nhận thanh toán'),
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

  String _paymentLabel(String id) {
    return _paymentMethods.firstWhere((method) => method['id'] == id)['label'] ?? id;
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
