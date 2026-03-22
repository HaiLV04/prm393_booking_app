import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/widgets/staff_widgets.dart';

class TableManagementScreen extends StatefulWidget {
  const TableManagementScreen({super.key});

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  final StaffOrderRepository _repository = StaffOrderRepository();
  late Future<_TablesVm> _tablesFuture;
  String _filterStatus = 'all'; // all, occupied, available, reserved, unavailable

  @override
  void initState() {
    super.initState();
    _tablesFuture = _loadVm();
  }

  Future<_TablesVm> _loadVm() async {
    final tables = await _repository.getTables();
    final reservations = await _repository.getReservations();
    return _TablesVm(tables: tables, reservations: reservations);
  }

  Future<void> _reload() async {
    setState(() {
      _tablesFuture = _loadVm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: FutureBuilder<_TablesVm>(
          future: _tablesFuture,
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
                onAction: _reload,
              );
            }

            final vm = snapshot.data ?? _TablesVm(tables: const [], reservations: const []);
            final tables = vm.tables;
            final filtered = _filterStatus == 'all'
                ? tables
                : tables.where((t) => t.status.toLowerCase() == _filterStatus).toList();
            final availableCount = tables.where((table) => table.status.toLowerCase() == 'available').length;
            final occupiedCount = tables.where((table) => table.status.toLowerCase() == 'occupied').length;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    StaffAppHeader(
                      title: 'Sơ đồ bàn',
                      subtitle: 'Quản lý',
                      onRefresh: _reload,
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
                                _buildFilterChip('Tất cả', 'all'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildFilterChip('Đang chiếm', 'occupied'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildFilterChip('Trống', 'available'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildFilterChip('Đặt trước', 'reserved'),
                              ],
                            ),
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing24),
                          Container(
                            padding: const EdgeInsets.all(StaffDesignSystem.spacing12),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              border: Border.all(color: context.borderColor),
                              borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryItem('Tổng bàn', '${tables.length}'),
                                ),
                                Expanded(
                                  child: _buildSummaryItem('Trống', '$availableCount'),
                                ),
                                Expanded(
                                  child: _buildSummaryItem('Đang phục vụ', '$occupiedCount'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing16),
                          // Tables grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: StaffDesignSystem.spacing12,
                              mainAxisSpacing: StaffDesignSystem.spacing12,
                              childAspectRatio: 1,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final table = filtered[index];
                              return _buildTableCard(table, vm.reservations);
                            },
                          ),
                          if (filtered.isEmpty) ...[
                            const SizedBox(height: StaffDesignSystem.spacing24),
                            EmptyState(
                              icon: Icons.table_chart_outlined,
                              title: 'Không có bàn',
                              description: 'Không có bàn với trạng thái này',
                              iconColor: StaffDesignSystem.primary.withValues(alpha: 0.3),
                            ),
                          ],
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

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;

    return FilterChip(
      selected: isSelected,
      onSelected: (selected) => setState(() => _filterStatus = value),
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

  Widget _buildTableCard(TableData table, List<ReservationData> reservations) {
    final statusColor = StaffDesignSystem.getTableStatusColor(table.status);

    return GestureDetector(
      onTap: () => _showTableActions(table, reservations),
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: StaffDesignSystem.shadowLight,
        ),
        child: Stack(
          children: [
            // Background color based on status
            Container(
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
              ),
            ),
            // Table info
            Padding(
              padding: const EdgeInsets.all(StaffDesignSystem.spacing12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Table number
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        table.name.replaceAll('Table', 'B'),
                        style: StaffTypography.titleMedium(context.isDarkMode)
                            .copyWith(color: statusColor),
                      ),
                    ),
                  ),
                  // Status and capacity
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _statusLabel(table.status),
                        style: StaffTypography.labelSmall(context.isDarkMode)
                            .copyWith(color: statusColor),
                      ),
                      const SizedBox(height: StaffDesignSystem.spacing4),
                      Text(
                        '${table.capacity} chỗ',
                        style: StaffTypography.bodySmall(context.isDarkMode),
                      ),
                    ],
                  ),
                  // Indicator dot
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ReservationData? _findActiveReservation(int tableId, List<ReservationData> reservations) {
    final active = reservations
        .where((reservation) {
          final status = reservation.status.toLowerCase();
          return reservation.tableId == tableId &&
              status != 'cancelled' &&
              status != 'completed' &&
              status != 'checkedout' &&
              status != 'finished';
        })
        .toList()
      ..sort((a, b) => b.checkInTime.compareTo(a.checkInTime));

    return active.isEmpty ? null : active.first;
  }

  Future<void> _showTableActions(TableData table, List<ReservationData> reservations) async {
    final activeReservation = _findActiveReservation(table.id, reservations);
    final normalizedStatus = table.status.toLowerCase();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('${table.name} (${table.capacity} chỗ)'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trạng thái hiện tại: ${_statusLabel(table.status)}'),
                const SizedBox(height: 14),
                if (activeReservation?.orderId != null)
                  _buildActionButtonInDialog(
                    icon: Icons.restaurant_menu,
                    label: 'Gọi món cho bàn này',
                    onTap: () {
                      Navigator.pop(dialogContext);
                      _openOrderForReservation(activeReservation!);
                    },
                  ),
                if (normalizedStatus == 'available')
                  _buildActionButtonInDialog(
                    icon: Icons.event_seat,
                    label: 'Đánh dấu đang phục vụ',
                    onTap: () async {
                      Navigator.pop(dialogContext);
                      await _setTableStatus(table.id, 'occupied', 'Đã đổi trạng thái sang Đang phục vụ');
                    },
                  ),
                if (normalizedStatus == 'occupied' || normalizedStatus == 'reserved')
                  _buildActionButtonInDialog(
                    icon: Icons.person_off_outlined,
                    label: 'Khách rời bàn',
                    onTap: () async {
                      Navigator.pop(dialogContext);
                      await _handleGuestLeft(activeReservation, table.id);
                    },
                  ),
                if (activeReservation?.orderId != null)
                  _buildActionButtonInDialog(
                    icon: Icons.receipt_long,
                    label: 'Hoàn thành hóa đơn',
                    onTap: () async {
                      Navigator.pop(dialogContext);
                      await _completeInvoice(activeReservation!);
                    },
                  ),
                if (normalizedStatus != 'available')
                  _buildActionButtonInDialog(
                    icon: Icons.check_circle_outline,
                    label: 'Đặt bàn về trạng thái trống',
                    onTap: () async {
                      Navigator.pop(dialogContext);
                      await _setTableStatus(table.id, 'available', 'Bàn đã chuyển về Trống');
                    },
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtonInDialog({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 18),
          label: Align(
            alignment: Alignment.centerLeft,
            child: Text(label),
          ),
        ),
      ),
    );
  }

  void _openOrderForReservation(ReservationData reservation) {
    final orderId = reservation.orderId;
    if (orderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bàn này chưa có order để gọi món.')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/staff/order',
      arguments: StaffOrderContext(
        tableId: reservation.tableId,
        tableName: reservation.tableName,
        reservationId: reservation.id,
        orderId: orderId,
        guestCount: reservation.guestCount,
        checkInTime: reservation.checkInTime,
        customerName: reservation.customerName,
      ),
    ).then((_) => _reload());
  }

  Future<void> _setTableStatus(int tableId, String status, String successMessage) async {
    final shouldContinue = await _confirmAction(
      title: 'Xác nhận cập nhật',
      message: 'Bạn có chắc muốn đổi trạng thái bàn sang "${_statusLabel(status)}"?',
      confirmLabel: 'Xác nhận',
    );
    if (!shouldContinue) {
      return;
    }

    try {
      await _repository.updateTableStatus(tableId: tableId, status: status);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
      await _reload();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _handleGuestLeft(ReservationData? reservation, int tableId) async {
    final shouldContinue = await _confirmAction(
      title: 'Xác nhận khách rời bàn',
      message: 'Thao tác này sẽ trả bàn về trạng thái trống. Bạn muốn tiếp tục?',
      confirmLabel: 'Đồng ý',
    );
    if (!shouldContinue) {
      return;
    }

    try {
      if (reservation != null) {
        await _repository.cancelReservation(reservation.id);
      } else {
        await _repository.updateTableStatus(tableId: tableId, status: 'available');
      }

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xử lý khách rời bàn.')),
      );
      await _reload();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _completeInvoice(ReservationData reservation) async {
    final orderId = reservation.orderId;
    if (orderId == null) {
      return;
    }

    final shouldContinue = await _confirmAction(
      title: 'Xác nhận hoàn thành hóa đơn',
      message: 'Hoá đơn sẽ được checkout với phương thức cash. Tiếp tục?',
      confirmLabel: 'Checkout',
    );
    if (!shouldContinue) {
      return;
    }

    try {
      await _repository.checkout(orderId: orderId, paymentMethod: 'cash');
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã hoàn thành hóa đơn.')),
      );
      await _reload();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<bool> _confirmAction({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: StaffTypography.headlineSmall(context.isDarkMode)),
        const SizedBox(height: 2),
        Text(label, style: StaffTypography.bodySmall(context.isDarkMode)),
      ],
    );
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Trống';
      case 'occupied':
        return 'Đang phục vụ';
      case 'reserved':
        return 'Đặt trước';
      case 'unavailable':
        return 'Ngưng phục vụ';
      default:
        return status;
    }
  }
}

class _TablesVm {
  const _TablesVm({required this.tables, required this.reservations});

  final List<TableData> tables;
  final List<ReservationData> reservations;
}
