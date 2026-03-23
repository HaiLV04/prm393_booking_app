import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/models/dashboard.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/admin_facility_repository.dart';
import 'package:prm393_booking_app/features/admin/data/services/dashboard_service.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/add_edit_table_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/manage_areas_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/manage_settings_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_detail_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_list_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTab = 0;
  bool _loadingSeed = true;
  String? _seedError;

  late final DashboardService _dashboardService;
  late final Future<DashboardData> _dashboardDataFuture;
  final AdminFacilityRepository _facilityRepository = AdminFacilityRepository();

  List<AreaItem> _areas = const <AreaItem>[];
  List<TableItem> _tables = const <TableItem>[];

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bg = Color(0xFFEFF3F1);
  static const Color _card = Colors.white;
  static const Color _text = Color(0xFF1B2637);
  static const Color _muted = Color(0xFF64748B);
  static const Color _border = Color(0xFFD7E1EA);

  @override
  void initState() {
    super.initState();
    _dashboardService = DashboardService();
    _dashboardDataFuture = _dashboardService.getDashboardData();
    _loadSeedData();
  }

  Future<void> _loadSeedData() async {
    setState(() {
      _loadingSeed = true;
      _seedError = null;
    });
    final route = [
      '/admin',
      '/admin/areas',
      '/admin/notifications',
      '/admin/settings',
    ][index];

    try {
      final areas = await _facilityRepository.getAreas();
      final tables = await _facilityRepository.getTables(pageSize: 100);
      if (!mounted) {
        return;
      }
      setState(() {
        _areas = areas;
        _tables = tables;
      });
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _seedError = e.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _seedError = 'Unable to load admin shortcuts');
      }
    } finally {
      if (mounted) {
        setState(() => _loadingSeed = false);
      }
    }
  }

  void _onTopTabTap(int index) {
    setState(() => _selectedTab = index);
    final route = ['/admin/dashboard', '/admin/tables', '/reservations', '/admin/menu'][index];
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }

  TableItem? get _firstTable => _tables.isEmpty ? null : _tables.first;
  AreaItem? get _firstArea => _areas.isEmpty ? null : _areas.first;

  @override
  Widget build(BuildContext context) {
    final tabs = ['Dashboard', 'Tables', 'Bookings', 'Menu'];

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Admin Panel',
          style: const TextStyle(
            color: _text,
            fontSize: 38,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadSeedData,
            icon: const Icon(Icons.refresh, color: _muted),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
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
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: _text,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionRow({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: disabled ? _card.withValues(alpha: 0.65) : _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Icon(icon, color: _primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: disabled ? _muted : _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(Icons.arrow_forward, color: disabled ? _muted : _primary),
          ],
        ),
      ),
    );
  }
}
