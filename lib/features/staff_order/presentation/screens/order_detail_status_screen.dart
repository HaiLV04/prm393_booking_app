import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_theme.dart';

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

  static const List<_PaymentMethodOption> _paymentMethods = <_PaymentMethodOption>[
    _PaymentMethodOption(value: 'cash', label: 'Tien mat'),
    _PaymentMethodOption(value: 'card', label: 'The'),
    _PaymentMethodOption(value: 'qr_transfer', label: 'Chuyen khoan QR'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = _load();
  }

  Future<_OrderDetailVm> _load() async {
    final arg = ModalRoute.of(context)?.settings.arguments;
    _context = arg is StaffOrderContext ? arg : await _repository.getActiveContext();
    if (_context == null) {
      throw Exception('Khong tim thay order dang phuc vu.');
    }

    final order = await _repository.getOrder(_context!.orderId);
    final items = await _repository.getOrderItems(_context!.orderId);

    return _OrderDetailVm(order: order, items: items, context: _context!);
  }

  Future<void> _checkout({required int orderId, required double taxAmount}) async {
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
        const SnackBar(content: Text('Da checkout thanh cong.')),
      );
      setState(() {
        _future = _load();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? StaffTheme.backgroundDark : StaffTheme.backgroundLight;
    final card = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final muted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: FutureBuilder<_OrderDetailVm>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Khong tai duoc chi tiet order', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('${snapshot.error}', textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => setState(() => _future = _load()),
                        child: const Text('Thu lai'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final vm = snapshot.data!;
            final vat = vm.order.totalAmount * 0.08;
            final grandTotal = vm.order.totalAmount + vat;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: border))),
                      child: Row(
                        children: [
                          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                          Expanded(
                            child: Text(
                              vm.context.tableName,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: titleColor),
                            ),
                          ),
                          IconButton(onPressed: () => setState(() => _future = _load()), icon: const Icon(Icons.refresh)),
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
                              color: isDark ? const Color(0x1F94A3B8) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: StaffTheme.primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.group, color: StaffTheme.primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${vm.context.guestCount} khach - ${_timeOfDay(vm.context.checkInTime)}',
                                    style: GoogleFonts.inter(color: titleColor, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text('Dang phuc vu', style: GoogleFonts.inter(fontSize: 12, color: muted)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text('Chi tiet mon goi', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: titleColor)),
                          const SizedBox(height: 10),
                          for (final item in vm.items)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: card,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: border),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: StaffTheme.primary.withValues(alpha: 0.12),
                                      ),
                                      child: const Icon(Icons.fastfood, color: StaffTheme.primary),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.menuItemName,
                                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: titleColor),
                                                ),
                                              ),
                                              Text(_formatVnd(item.unitPrice), style: GoogleFonts.inter(fontSize: 16, color: titleColor, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text('So luong: ${item.quantity}', style: GoogleFonts.inter(color: muted)),
                                          const SizedBox(height: 6),
                                          _statusChip(item.itemStatus),
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
                              color: isDark ? const Color(0x1F94A3B8) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: border),
                            ),
                            child: Text(
                              vm.order.note.isEmpty ? 'Khong co ghi chu cho bep.' : vm.order.note,
                              style: GoogleFonts.inter(color: muted),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(border: Border(top: BorderSide(color: border))),
                            child: Column(
                              children: [
                                _summaryRow('Tong tien mon (${vm.items.length})', _formatVnd(vm.order.totalAmount), muted),
                                _summaryRow('Thue VAT (8%)', _formatVnd(vat), muted),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Thanh tien', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: titleColor)),
                                    Text(_formatVnd(grandTotal), style: GoogleFonts.inter(fontSize: 21, color: StaffTheme.primary, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  initialValue: _paymentMethod,
                                  decoration: InputDecoration(
                                    labelText: 'Phuong thuc thanh toan',
                                    labelStyle: GoogleFonts.inter(color: muted),
                                    filled: true,
                                    fillColor: card,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: border),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: border),
                                    ),
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
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: StaffTheme.primary, width: 2),
                                          foregroundColor: StaffTheme.primary,
                                          padding: const EdgeInsets.symmetric(vertical: 13),
                                        ),
                                        onPressed: () => Navigator.pushNamed(context, '/staff/order', arguments: vm.context),
                                        icon: const Icon(Icons.add_circle),
                                        label: const Text('Goi them mon'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: FilledButton.icon(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: StaffTheme.primary,
                                          foregroundColor: StaffTheme.backgroundDark,
                                          padding: const EdgeInsets.symmetric(vertical: 13),
                                        ),
                                        onPressed: () => _checkout(orderId: vm.order.id, taxAmount: vat),
                                        icon: const Icon(Icons.payments),
                                        label: const Text('Thanh toan'),
                                      ),
                                    ),
                                  ],
                                ),
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

  Widget _statusChip(String status) {
    final normalized = status.toLowerCase();
    var color = const Color(0xFF64748B);
    var label = status;

    if (normalized == 'pending') {
      color = const Color(0xFFF59E0B);
      label = 'Cho bep';
    } else if (normalized == 'preparing') {
      color = const Color(0xFF3B82F6);
      label = 'Dang che bien';
    } else if (normalized == 'served') {
      color = const Color(0xFF22C55E);
      label = 'Da len mon';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(label, style: GoogleFonts.inter(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _summaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: color, fontSize: 13)),
          Text(value, style: GoogleFonts.inter(color: color, fontSize: 13)),
        ],
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
    return '${buffer.toString().split('').reversed.join()}d';
  }

  String _timeOfDay(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
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

class _PaymentMethodOption {
  const _PaymentMethodOption({required this.value, required this.label});

  final String value;
  final String label;
}
