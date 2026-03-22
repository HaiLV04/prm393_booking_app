import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/models/dashboard.dart';
import 'package:prm393_booking_app/features/admin/data/services/dashboard_service.dart';
import '../../style/admin_dashboard_styles.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  late final DashboardService _dashboardService;
  late final Future<DashboardData> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardService = DashboardService();
    _dashboardDataFuture = _dashboardService.getDashboardData();
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    final route = [
      '/admin/dashboard',
      '/admin/areas',
      '/admin/notifications',
      '/admin/settings',
    ][index];

    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = AdminDashboardStyles.background;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg.withOpacity(0.9),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Dashboard',
          style: AdminDashboardStyles.headerTitle(context),
        ),
        leading: null,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg',
                        ),
                      ),
                      border: Border.all(
                        color: AdminDashboardStyles.primary.withOpacity(0.12),
                        width: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chào mừng, Admin',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Quản lý nhà hàng của bạn',
                        style: AdminDashboardStyles.smallMuted(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              FutureBuilder<DashboardData>(
                future: _dashboardDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data =
                      snapshot.data ??
                      const DashboardData(
                        totalTables: 0,
                        occupiedTables: 0,
                        todayOrders: 0,
                        revenue: 0.0,
                      );

                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _summaryCard(
                        context,
                        'Tổng bàn',
                        data.totalTables.toString(),
                        Icons.table_restaurant,
                      ),
                      _summaryCard(
                        context,
                        'Đang dùng',
                        data.occupiedTables.toString(),
                        Icons.groups,
                      ),
                      _summaryCard(
                        context,
                        'Order hôm nay',
                        data.todayOrders.toString(),
                        Icons.receipt_long,
                      ),
                      _summaryCard(
                        context,
                        'Doanh thu',
                        '${(data.revenue / 1000000).toStringAsFixed(1)}M',
                        Icons.payments,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              Text(
                'Quick Actions',
                style: AdminDashboardStyles.headerTitle(context),
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _actionButton(
                    context,
                    Icons.bar_chart,
                    'Thống kê',
                    () => Navigator.pushNamed(context, '/admin/statistics'),
                  ),
                  _actionButton(
                    context,
                    Icons.badge,
                    'Nhân viên',
                    () => Navigator.pushNamed(context, '/admin/staff'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Khu vực'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final cardColor = AdminDashboardStyles.primary.withOpacity(0.06);
    final textColor = AdminDashboardStyles.primary;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AdminDashboardStyles.cardRadius,
        border: Border.all(
          color: AdminDashboardStyles.primary.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AdminDashboardStyles.smallMuted(context)),
              Icon(icon, color: AdminDashboardStyles.primary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AdminDashboardStyles.largeNumber(
              context,
            ).copyWith(color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback? onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AdminDashboardStyles.card,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AdminDashboardStyles.borderColor),
                ),
                child: Icon(icon, color: AdminDashboardStyles.primary),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
