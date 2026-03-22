import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/widgets/staff_widgets.dart';
import 'package:prm393_booking_app/features/staff_profile/presentation/screens/manage_profile_screen.dart';
import 'table_management_screen.dart';
import 'order_management_screen.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  final StaffOrderRepository _repository = StaffOrderRepository();
  late Future<_DashboardVm> _dashboardFuture;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _loadDashboard();
  }

  Future<_DashboardVm> _loadDashboard() async {
    final reservations = await _repository.getReservations();
    final tables = await _repository.getTables();

    final today = DateTime.now();
    final todayCount = reservations.where((reservation) {
      final created = reservation.createdAt;
      return created.year == today.year &&
          created.month == today.month &&
          created.day == today.day;
    }).length;

    final servingCount = reservations.where((reservation) {
      final status = reservation.status.toLowerCase();
      return status != 'cancelled' && reservation.orderId != null;
    }).length;

    final occupiedTables = tables
        .where((table) => table.status.toLowerCase() == 'occupied')
        .length;
    final capacity = tables.isEmpty ? 0 : (occupiedTables / tables.length * 100).round();

    final latest = List<ReservationData>.from(reservations)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return _DashboardVm(
      todayCount: todayCount,
      servingCount: servingCount,
      capacityPercent: capacity,
      occupiedTables: occupiedTables,
      totalTables: tables.length,
      notices: latest.take(3).toList(),
    );
  }

  Future<void> _openOrder() async {
    final tables = await _repository.getTables();
    final reservations = await _repository.getReservations();

    final options = tables
        .where((table) => table.isActive)
        .map((table) {
          final activeReservations = reservations
              .where((reservation) =>
                  reservation.tableId == table.id &&
                  _isServingStatus(reservation.status) &&
                  reservation.orderId != null)
              .toList()
            ..sort((a, b) => b.checkInTime.compareTo(a.checkInTime));

          return _OrderTableOption(
            table: table,
            activeReservation: activeReservations.isEmpty ? null : activeReservations.first,
          );
        })
        .toList()
      ..sort((a, b) => a.table.name.compareTo(b.table.name));

    if (!mounted) {
      return;
    }

    if (options.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có bàn khả dụng để gọi món.')),
      );
      return;
    }

    final selectedOption = await showDialog<_OrderTableOption>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Chọn bàn để gọi món'),
          content: SizedBox(
            width: 420,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, index) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final option = options[index];
                  final reservation = option.activeReservation;
                  final status = option.table.status.toLowerCase();
                  final hasOrder = reservation?.orderId != null;
                  final statusLabel = hasOrder
                      ? 'Đang phục vụ'
                      : status == 'available'
                          ? 'Bàn trống'
                          : option.table.status;

                  return ListTile(
                    leading: const Icon(Icons.table_restaurant_outlined),
                    title: Text(option.table.name),
                    subtitle: Text(
                      hasOrder
                          ? '${reservation!.guestCount} khách - ${reservation.customerName}'
                          : 'Sức chứa ${option.table.capacity} khách',
                    ),
                    trailing: StatusBadge(status: statusLabel),
                    onTap: () => Navigator.pop(dialogContext, option),
                  );
                },
              ),
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

    if (!mounted || selectedOption == null) {
      return;
    }

    StaffOrderContext? selectedContext;
    final activeReservation = selectedOption.activeReservation;
    if (activeReservation?.orderId != null) {
      selectedContext = StaffOrderContext(
        tableId: activeReservation!.tableId,
        tableName: activeReservation.tableName,
        reservationId: activeReservation.id,
        orderId: activeReservation.orderId!,
        guestCount: activeReservation.guestCount,
        checkInTime: activeReservation.checkInTime,
        customerName: activeReservation.customerName,
      );
    } else {
      selectedContext = await _quickCheckIn(selectedOption.table);
    }

    if (!mounted || selectedContext == null) {
      return;
    }

    Navigator.pushNamed(context, '/staff/order', arguments: selectedContext).then((_) {
      setState(() => _dashboardFuture = _loadDashboard());
    });
  }

  Future<StaffOrderContext?> _quickCheckIn(TableData table) async {
    final formKey = GlobalKey<FormState>();
    final customerNameCtrl = TextEditingController();
    final customerPhoneCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    int guestCount = table.capacity > 0 ? 1 : 1;

    final payload = await showDialog<_QuickCheckInPayload>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Nhận khách - ${table.name}'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: customerNameCtrl,
                        decoration: const InputDecoration(labelText: 'Tên khách hàng'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập tên khách';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: customerPhoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Số điện thoại'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập số điện thoại';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Số khách'),
                          const Spacer(),
                          IconButton(
                            onPressed: guestCount > 1
                                ? () => setDialogState(() => guestCount -= 1)
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('$guestCount'),
                          IconButton(
                            onPressed: guestCount < table.capacity
                                ? () => setDialogState(() => guestCount += 1)
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: noteCtrl,
                        decoration: const InputDecoration(labelText: 'Ghi chú (tuỳ chọn)'),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Huỷ'),
                ),
                FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    Navigator.pop(
                      dialogContext,
                      _QuickCheckInPayload(
                        customerName: customerNameCtrl.text.trim(),
                        customerPhone: customerPhoneCtrl.text.trim(),
                        guestCount: guestCount,
                        note: noteCtrl.text.trim(),
                      ),
                    );
                  },
                  child: const Text('Nhận bàn'),
                ),
              ],
            );
          },
        );
      },
    );

    if (payload == null) {
      return null;
    }

    try {
      final contextCreated = await _repository.checkInAndCreateOrder(
        tableId: table.id,
        tableName: table.name,
        guestCount: payload.guestCount,
        customerName: payload.customerName,
        customerPhone: payload.customerPhone,
        note: payload.note,
      );

      if (!mounted) {
        return null;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã nhận khách cho ${table.name}.')),
      );
      setState(() => _dashboardFuture = _loadDashboard());
      return contextCreated;
    } catch (e) {
      if (!mounted) {
        return null;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  bool _isServingStatus(String status) {
    final normalized = status.trim().toLowerCase();
    const closed = <String>{'cancelled', 'completed', 'checkedout', 'finished'};
    return !closed.contains(normalized);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      bottomNavigationBar: _buildBottomNavigation(),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: StaffDesignSystem.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x142F7EF7),
              ),
            ),
          ),
          SafeArea(
            child: IndexedStack(
              index: _selectedNavIndex,
              children: [
            // Index 0: Dashboard
            FutureBuilder<_DashboardVm>(
              future: _dashboardFuture,
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
                    onAction: () => setState(() => _dashboardFuture = _loadDashboard()),
                  );
                }

                final vm = snapshot.data!;

                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        StaffAppHeader(
                          title: 'Bảng điều khiển',
                          subtitle: 'Nhân viên',
                          onRefresh: () => setState(() => _dashboardFuture = _loadDashboard()),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: StaffDesignSystem.spacing16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Key Metrics Section
                              _buildMetricsSection(vm),
                              const SizedBox(height: StaffDesignSystem.spacing32),

                              // Quick Actions Section
                              _buildQuickActionsSection(),
                              const SizedBox(height: StaffDesignSystem.spacing32),

                              // Recent Activity Section
                              _buildRecentActivitySection(vm),
                              const SizedBox(height: StaffDesignSystem.spacing16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Index 1: Tables
            const TableManagementScreen(),
            // Index 2: Orders
            const OrderManagementScreen(),
            // Index 3: Profile
                const ManageProfileScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(_DashboardVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(title: 'Tình trạng hiện tại'),
        const SizedBox(height: StaffDesignSystem.spacing16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: StaffDesignSystem.spacing12,
          mainAxisSpacing: StaffDesignSystem.spacing12,
          childAspectRatio: 1.2,
          children: [
            ModernStatCard(
              icon: Icons.calendar_today_outlined,
              label: 'Đặt hôm nay',
              value: '${vm.todayCount}',
              color: StaffDesignSystem.info,
            ),
            ModernStatCard(
              icon: Icons.people_alt_outlined,
              label: 'Đang phục vụ',
              value: '${vm.servingCount}',
              color: StaffDesignSystem.success,
            ),
            ModernStatCard(
              icon: Icons.table_chart_outlined,
              label: 'Bàn được chiếm',
              value: '${vm.occupiedTables}/${vm.totalTables}',
              color: StaffDesignSystem.warning,
            ),
            ModernStatCard(
              icon: Icons.trending_up,
              label: 'Công suất',
              value: '${vm.capacityPercent}',
              unit: '%',
              color: StaffDesignSystem.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(title: 'Các tác vụ nhanh'),
        const SizedBox(height: StaffDesignSystem.spacing16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: StaffDesignSystem.spacing12,
          mainAxisSpacing: StaffDesignSystem.spacing12,
          childAspectRatio: 1.0,
          children: [
            QuickActionCard(
              icon: Icons.restaurant_menu,
              label: 'Gọi món',
              description: 'Thêm món cho bàn',
              onTap: _openOrder,
              color: StaffDesignSystem.primary,
            ),
            QuickActionCard(
              icon: Icons.table_restaurant,
              label: 'Sơ đồ bàn',
              description: 'Xem trạng thái bàn',
              onTap: () => setState(() => _selectedNavIndex = 1),
              color: StaffDesignSystem.info,
            ),
            QuickActionCard(
              icon: Icons.receipt_long,
              label: 'Thanh toán',
              description: 'Xử lý hóa đơn',
              onTap: () => setState(() => _selectedNavIndex = 2),
              color: StaffDesignSystem.warning,
            ),
            QuickActionCard(
              icon: Icons.event_available,
              label: 'Đặt chỗ mới',
              description: 'Tạo đặt phòng',
              onTap: () {
                Navigator.pushNamed(context, '/staff/reservation/create').then((_) {
                  setState(() => _dashboardFuture = _loadDashboard());
                });
              },
              color: StaffDesignSystem.success,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection(_DashboardVm vm) {
    if (vm.notices.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(title: 'Hoạt động gần đây'),
          const SizedBox(height: StaffDesignSystem.spacing16),
          EmptyState(
            icon: Icons.history_outlined,
            title: 'Không có hoạt động',
            description: 'Chưa có thay đổi trạng thái gần đây',
            iconColor: StaffDesignSystem.primary.withValues(alpha: 0.3),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(title: 'Hoạt động gần đây'),
        const SizedBox(height: StaffDesignSystem.spacing12),
        ...vm.notices.map((reservation) => Padding(
          padding: const EdgeInsets.only(bottom: StaffDesignSystem.spacing12),
          child: ListItemCard(
            title: 'Bàn ${reservation.tableName}',
            subtitle: '${reservation.guestCount} khách - ${reservation.customerName}',
            leadingIcon: Icons.event_seat,
            badge: StaffDesignSystem.getStatusLabel(reservation.status),
            badgeColor: StaffDesignSystem.getStatusColor(reservation.status),
          ),
        )),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.borderColor),
        boxShadow: StaffDesignSystem.shadowLarge,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: _selectedNavIndex,
          onTap: (index) => setState(() => _selectedNavIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: StaffDesignSystem.primaryDark,
          unselectedItemColor: context.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Bảng điều khiển',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_chart_outlined),
              activeIcon: Icon(Icons.table_chart),
              label: 'Bàn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Đơn hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardVm {
  final int todayCount;
  final int servingCount;
  final int capacityPercent;
  final int occupiedTables;
  final int totalTables;
  final List<ReservationData> notices;

  _DashboardVm({
    required this.todayCount,
    required this.servingCount,
    required this.capacityPercent,
    required this.occupiedTables,
    required this.totalTables,
    required this.notices,
  });
}

class _OrderTableOption {
  const _OrderTableOption({required this.table, required this.activeReservation});

  final TableData table;
  final ReservationData? activeReservation;
}

class _QuickCheckInPayload {
  const _QuickCheckInPayload({
    required this.customerName,
    required this.customerPhone,
    required this.guestCount,
    required this.note,
  });

  final String customerName;
  final String customerPhone;
  final int guestCount;
  final String note;
}
