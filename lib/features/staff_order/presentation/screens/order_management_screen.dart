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
  String _selectedStatus = 'all'; // all, pending, confirmed, serving, completed, cancelled

  @override
  void initState() {
    super.initState();
    _reservationsFuture = _repository.getReservations();
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
                onAction: () => setState(() => _reservationsFuture = _repository.getReservations()),
              );
            }

            final reservations = snapshot.data ?? [];
            final filtered = _selectedStatus == 'all'
                ? reservations
                : reservations.where((r) => r.status.toLowerCase() == _selectedStatus).toList();

            // Sort by creation date descending
            filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    StaffAppHeader(
                      title: 'Đơn hàng',
                      subtitle: 'Quản lý',
                      onRefresh: () => setState(() => _reservationsFuture = _repository.getReservations()),
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
                          // Filter chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildStatusChip('Tất cả', 'all'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildStatusChip('Chờ', 'pending'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildStatusChip('Xác nhận', 'confirmed'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildStatusChip('Phục vụ', 'serving'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildStatusChip('Xong', 'completed'),
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
                              children: filtered.map((reservation) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: StaffDesignSystem.spacing12),
                                  child: _buildOrderCard(reservation),
                                );
                              }).toList(),
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
        color: isSelected
            ? StaffDesignSystem.primary
            : context.borderColor,
      ),
    );
  }

  Widget _buildOrderCard(ReservationData reservation) {
    return Container(
      padding: const EdgeInsets.all(StaffDesignSystem.spacing12),
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
        boxShadow: StaffDesignSystem.shadowLight,
      ),
      child: Column(
        children: [
          // Header: Table info and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bàn ${reservation.tableName}',
                      style: StaffTypography.titleMedium(context.isDarkMode),
                    ),
                    const SizedBox(height: StaffDesignSystem.spacing4),
                    Text(
                      reservation.customerName,
                      style: StaffTypography.bodySmall(context.isDarkMode),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: reservation.status),
            ],
          ),
          const SizedBox(height: StaffDesignSystem.spacing12),
          Divider(color: context.borderColor, height: 1),
          const SizedBox(height: StaffDesignSystem.spacing12),
          
          // Details row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(
                Icons.people_outlined,
                '${reservation.guestCount}',
                'khách',
              ),
              _buildDetailItem(
                Icons.access_time_outlined,
                _formatTime(reservation.createdAt),
                'vừa',
              ),
              _buildDetailItem(
                Icons.event_seat_outlined,
                reservation.tableName,
                'khu vực',
              ),
            ],
          ),
          
          if (reservation.orderId != null) ...[
            const SizedBox(height: StaffDesignSystem.spacing12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () {
                  // Navigate to order detail
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
                child: const Text('Xem chi tiết'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: context.textSecondary),
        const SizedBox(height: StaffDesignSystem.spacing4),
        Text(
          value,
          style: StaffTypography.labelMedium(context.isDarkMode),
        ),
        const SizedBox(height: StaffDesignSystem.spacing2),
        Text(
          label,
          style: StaffTypography.bodySmall(context.isDarkMode),
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
