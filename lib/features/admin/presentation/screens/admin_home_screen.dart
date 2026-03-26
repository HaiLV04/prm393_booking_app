import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/core/models/dashboard.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/admin_facility_repository.dart';
import 'package:prm393_booking_app/features/admin/data/services/dashboard_service.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/manage_areas_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/manage_settings_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _primary => const Color(0xFF13EC5B);
  Color get _bg => _isDark ? const Color(0xFF0B2518) : const Color(0xFFF0F5F2);
  Color get _card => _isDark ? const Color(0xFF143523) : Colors.white;
  Color get _muted =>
      _isDark ? const Color(0xFFA0B9AA) : const Color(0xFF6B8074);
  Color get _textColor => _isDark ? Colors.white : const Color(0xFF0B2518);
  Color get _border =>
      _isDark ? const Color(0xFF1F4630) : const Color(0xFFE2EBE5);

  final _repository = AdminFacilityRepository();
  final _dashboardService = DashboardService();

  bool _loading = true;
  String? _error;
  List<AreaItem> _areas = const [];
  List<TableItem> _tables = const [];
  DashboardData _dashboard = const DashboardData(
    totalTables: 0,
    occupiedTables: 0,
    todayOrders: 0,
    revenue: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadSeedData();
  }

  Future<void> _loadSeedData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _repository.getAreas(),
        _repository.getTables(pageSize: 100),
        _dashboardService.getDashboardData(),
      ]);

      final areas = results[0] as List<AreaItem>;
      final tables = results[1] as List<TableItem>;
      final dashboard = results[2] as DashboardData;

      if (!mounted) return;
      setState(() {
        _areas = areas;
        _tables = tables;
        _dashboard = dashboard;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Không thể tải dữ liệu bảng điều khiển');
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  AreaItem? get _firstArea => _areas.isEmpty ? null : _areas.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: _primary))
            : _error != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _error!,
                      style: GoogleFonts.manrope(color: _textColor),
                    ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: _loadSeedData,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadSeedData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _border),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                'https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chào mừng, Admin',
                                style: GoogleFonts.manrope(
                                  color: _textColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Quản lý nhà hàng và cấu hình hệ thống',
                                style: GoogleFonts.manrope(
                                  color: _muted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _loadSeedData,
                          icon: Icon(Icons.refresh, color: _muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Thống kê hôm nay',
                      style: GoogleFonts.manrope(
                        color: _textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.55,
                      children: [
                        _summaryCard(
                          title: 'Tổng bàn',
                          value: _dashboard.totalTables.toString(),
                          icon: Icons.table_restaurant,
                        ),
                        _summaryCard(
                          title: 'Đang sử dụng',
                          value: _dashboard.occupiedTables.toString(),
                          icon: Icons.groups,
                        ),
                        _summaryCard(
                          title: 'Đơn hôm nay',
                          value: _dashboard.todayOrders.toString(),
                          icon: Icons.receipt_long,
                        ),
                        _summaryCard(
                          title: 'Doanh thu',
                          value:
                              '${(_dashboard.revenue / 1000000).toStringAsFixed(1)}M',
                          icon: Icons.payments,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Thao tác nhanh',
                      style: GoogleFonts.manrope(
                        color: _textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: [
                        _quickActionButton(
                          icon: Icons.bar_chart,
                          label: 'Thống kê',
                          onTap: () =>
                              Navigator.pushNamed(context, '/admin/statistics'),
                        ),
                        _quickActionButton(
                          icon: Icons.badge,
                          label: 'Nhân viên',
                          onTap: () =>
                              Navigator.pushNamed(context, '/admin/staff'),
                        ),
                        _quickActionButton(
                          icon: Icons.map,
                          label: 'Khu vực',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageAreasScreen(),
                              ),
                            );
                          },
                        ),

                        _quickActionButton(
                          icon: Icons.restaurant_menu,
                          label: 'Danh mục món',
                          onTap: () =>
                              Navigator.pushNamed(context, '/admin/menu'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cài đặt',
                      style: GoogleFonts.manrope(
                        color: _textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _actionCard(
                      title: 'Cài đặt hệ thống',
                      subtitle: 'Quản lý cấu hình chung của nhà hàng',
                      icon: Icons.settings,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageSettingsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _actionCard(
                      title: 'Đăng xuất',
                      subtitle: 'Thoát khỏi tài khoản quản trị hiện tại',
                      icon: Icons.logout,
                      onTap: _handleLogout,
                    ),
                    if (_firstArea == null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Lưu ý: Cần tạo khu vực trước khi mở Sơ đồ bàn.',
                        style: GoogleFonts.manrope(
                          color: _muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(icon, color: _primary, size: 18),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: _primary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final disabled = onTap == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: disabled ? _card.withValues(alpha: 0.6) : _card,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _border),
                ),
                child: Icon(
                  icon,
                  color: disabled ? _muted.withValues(alpha: 0.7) : _primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: disabled ? _muted : _textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: disabled ? _card.withValues(alpha: 0.6) : _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      color: _textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.manrope(
                        color: _muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: disabled ? const Color(0xFF607E6E) : _muted,
            ),
          ],
        ),
      ),
    );
  }
}
