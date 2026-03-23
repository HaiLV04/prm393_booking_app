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
              Text(
                'Facility & Configuration Control',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: List.generate(tabs.length, (index) {
                  final active = index == _selectedTab;
                  return Expanded(
                    child: InkWell(
                      onTap: () => _onTopTabTap(index),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color: active ? _primary : _muted,
                                fontSize: 21,
                                fontWeight:
                                    active ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 3,
                            color: active ? _primary : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              FutureBuilder<DashboardData>(
                future: _dashboardDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final data =
                      snapshot.data ??
                      const DashboardData(
                        totalTables: 0,
                        occupiedTables: 0,
                        todayOrders: 0,
                        revenue: 0.0,
                      );

                  final availableTables =
                      (data.totalTables - data.occupiedTables).clamp(
                        0,
                        data.totalTables,
                      );

                  return Column(
                    children: [
                      _summaryCard(
                        title: 'Total Bookings',
                        value: data.todayOrders.toString(),
                        icon: Icons.calendar_today,
                        iconBg: const Color(0xFFD7F6E3),
                        iconColor: _primary,
                      ),
                      const SizedBox(height: 10),
                      _summaryCard(
                        title: 'Available Tables',
                        value: '$availableTables/${data.totalTables}',
                        icon: Icons.table_restaurant,
                        iconBg: const Color(0xFFDCEFFA),
                        iconColor: const Color(0xFF1EA7E1),
                      ),
                      const SizedBox(height: 10),
                      _summaryCard(
                        title: 'Revenue Today',
                        value: '\$${data.revenue.toStringAsFixed(0)}',
                        icon: Icons.attach_money,
                        iconBg: const Color(0xFFF8ECD8),
                        iconColor: const Color(0xFFE98D14),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Quick Actions',
                style: TextStyle(
                  color: _text,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              _actionRow(
                icon: Icons.add,
                label: 'Add New Table',
                onTap: () async {
                  final changed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddEditTableScreen(),
                    ),
                  );
                  if (changed == true) {
                    _loadSeedData();
                  }
                },
              ),
              const SizedBox(height: 10),
              _actionRow(
                icon: Icons.map,
                label: 'Manage Areas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ManageAreasScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _actionRow(
                icon: Icons.grid_view,
                label: 'View Table Map',
                onTap: _firstArea == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TableListScreen(
                              areaName: _firstArea!.name,
                              areaId: _firstArea!.id.toString(),
                            ),
                          ),
                        );
                      },
              ),
              const SizedBox(height: 10),
              _actionRow(
                icon: Icons.info_outline,
                label: 'View Table Details',
                onTap: _firstTable == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TableDetailScreen(
                              tableId: _firstTable!.id.toString(),
                              tableName: _firstTable!.name,
                            ),
                          ),
                        );
                      },
              ),
              const SizedBox(height: 10),
              _actionRow(
                icon: Icons.settings,
                label: 'Manage Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ManageSettingsScreen()),
                  );
                },
              ),

              if (_loadingSeed)
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: LinearProgressIndicator(minHeight: 3),
                ),
              if (_seedError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _seedError!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
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
