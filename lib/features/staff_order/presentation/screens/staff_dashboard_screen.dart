import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/widgets/staff_widgets.dart';

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
    final activeContext = await _repository.getActiveContext();

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
      activeContext: activeContext,
      notices: latest.take(3).toList(),
    );
  }

  void _openOrder(BuildContext context, StaffOrderContext? orderCtx) {
    if (orderCtx == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy bàn đang phục vụ để gọi món.')),
      );
      return;
    }
    Navigator.pushNamed(context, '/staff/order', arguments: orderCtx).then((_) {
      setState(() => _dashboardFuture = _loadDashboard());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: FutureBuilder<_DashboardVm>(
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
                child: Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.only(bottom: 80),
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
                              _buildQuickActionsSection(vm),
                              const SizedBox(height: StaffDesignSystem.spacing32),
                              
                              // Recent Activity Section
                              _buildRecentActivitySection(vm),
                              const SizedBox(height: StaffDesignSystem.spacing16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Bottom Navigation
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildBottomNavigation(),
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
            MetricCard(
              icon: Icons.calendar_today_outlined,
              label: 'Đặt hôm nay',
              value: '${vm.todayCount}',
              color: StaffDesignSystem.info,
            ),
            MetricCard(
              icon: Icons.people_alt_outlined,
              label: 'Đang phục vụ',
              value: '${vm.servingCount}',
              color: StaffDesignSystem.success,
            ),
            MetricCard(
              icon: Icons.table_chart_outlined,
              label: 'Bàn được chiếm',
              value: '${vm.occupiedTables}/${vm.totalTables}',
              color: StaffDesignSystem.warning,
            ),
            MetricCard(
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

  Widget _buildQuickActionsSection(_DashboardVm vm) {
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
              onTap: () => _openOrder(context, vm.activeContext),
              color: StaffDesignSystem.primary,
            ),
            QuickActionCard(
              icon: Icons.table_restaurant,
              label: 'Sơ đồ bàn',
              description: 'Xem trạng thái bàn',
              onTap: () {},
              color: StaffDesignSystem.info,
            ),
            QuickActionCard(
              icon: Icons.receipt_long,
              label: 'Thanh toán',
              description: 'Xử lý hóa đơn',
              onTap: () {},
              color: StaffDesignSystem.warning,
            ),
            QuickActionCard(
              icon: Icons.event_available,
              label: 'Đặt chỗ mới',
              description: 'Tạo đặt phòng',
              onTap: () {},
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
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(
          top: BorderSide(color: context.borderColor),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: StaffDesignSystem.primary,
        unselectedItemColor: context.textSecondary,
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
    );
  }
}

class _DashboardVm {
  final int todayCount;
  final int servingCount;
  final int capacityPercent;
  final int occupiedTables;
  final int totalTables;
  final StaffOrderContext? activeContext;
  final List<ReservationData> notices;

  _DashboardVm({
    required this.todayCount,
    required this.servingCount,
    required this.capacityPercent,
    required this.occupiedTables,
    required this.totalTables,
    required this.activeContext,
    required this.notices,
  });
}
