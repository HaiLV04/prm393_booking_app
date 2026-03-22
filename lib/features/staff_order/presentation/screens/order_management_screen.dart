import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/widgets/staff_widgets.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final StaffOrderRepository _repository = StaffOrderRepository();
  late Future<List<ReservationData>> _reservationsFuture;
  String _selectedStatus = 'all';
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _reservationsFuture = _repository.getReservations();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _reservationsFuture = _repository.getReservations();
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: FutureBuilder<List<ReservationData>>(
          future: _reservationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return EmptyState(
                icon: Icons.error_outline,
                title: 'Không tải được dữ liệu',
                description: snapshot.error.toString(),
                actionLabel: 'Thử lại',
                onAction: () {
                  setState(() {
                    _reservationsFuture = _repository.getReservations();
                  });
                },
              );
            }

            final reservations = snapshot.data ?? [];
            final filtered = _selectedStatus == 'all'
                ? reservations
                : reservations.where((r) => r.status.toLowerCase() == _selectedStatus).toList();
            filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final servingCount = reservations.where((r) => r.status.toLowerCase() == 'serving').length;
            final completedCount = reservations.where((r) => r.status.toLowerCase() == 'completed').length;
            final pendingCount = reservations.where((r) => r.status.toLowerCase() == 'pending').length;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    StaffAppHeader(
                      title: 'Đơn hàng',
                      subtitle: 'Quản lý',
                      onRefresh: () {
                        setState(() {
                          _reservationsFuture = _repository.getReservations();
                        });
                      },
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          StaffDesignSystem.spacing16,
                          StaffDesignSystem.spacing16,
                          StaffDesignSystem.spacing16,
                          StaffDesignSystem.spacing16,
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(StaffDesignSystem.spacing12),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              border: Border.all(color: context.borderColor),
                              borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: _buildSummaryItem('Tổng đơn', '${reservations.length}')),
                                Expanded(child: _buildSummaryItem('Đang phục vụ', '$servingCount')),
                                Expanded(child: _buildSummaryItem('Chờ xử lý', '$pendingCount')),
                                Expanded(child: _buildSummaryItem('Hoàn tất', '$completedCount')),
                              ],
                            ),
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildStatusChip('Tất cả', 'all'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildStatusChip('Chờ xử lý', 'pending'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildStatusChip('Xác nhận', 'confirmed'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildStatusChip('Phục vụ', 'serving'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildStatusChip('Hoàn tất', 'completed'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildStatusChip('Đã hủy', 'cancelled'),
                              ],
                            ),
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing24),
                          if (filtered.isEmpty)
                            EmptyState(
                              icon: Icons.receipt_long_outlined,
                              title: 'Không có đơn hàng',
                              description: 'Không có đơn hàng với trạng thái này',
                              iconColor: StaffDesignSystem.primary.withValues(alpha: 0.3),
                            )
                          else
                            Column(
                              children: filtered
                                  .map(
                                    (reservation) => Padding(
                                      padding: const EdgeInsets.only(bottom: StaffDesignSystem.spacing12),
                                      child: _buildOrderCard(reservation),
                                    ),
                                  )
                                  .toList(),
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

  Widget _buildStatusChip(String label, String value) {
    final isSelected = _selectedStatus == value;

    return FilterChip(
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedStatus = value),
      label: Text(label),
      backgroundColor: context.cardColor,
      selectedColor: StaffDesignSystem.primary.withValues(alpha: 0.15),
      side: BorderSide(
        color: isSelected ? StaffDesignSystem.primary : context.borderColor,
      ),
    );
  }

  Widget _buildOrderCard(ReservationData reservation) {
    return ModernOrderCard(
      tableName: reservation.tableName.replaceAll('Table', 'Bàn'),
      customerName: reservation.customerName,
      guestCount: reservation.guestCount,
      timeText: _formatTime(reservation.createdAt),
      status: reservation.status,
      onOpen: reservation.orderId == null
          ? null
          : () {
              Navigator.pushNamed(
                context,
                '/staff/order-detail',
                arguments: StaffOrderContext(
                  tableId: reservation.tableId,
                  tableName: reservation.tableName,
                  reservationId: reservation.id,
                  orderId: reservation.orderId!,
                  guestCount: reservation.guestCount,
                  checkInTime: reservation.createdAt,
                  customerName: reservation.customerName,
                ),
              );
            },
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: StaffTypography.headlineSmall(context.isDarkMode)),
        const SizedBox(height: 2),
        Text(
          label,
          style: StaffTypography.bodySmall(context.isDarkMode),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'Vừa';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}p';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else {
      return '${diff.inDays}d';
    }
  }
}
