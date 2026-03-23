import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/admin_facility_repository.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/add_edit_table_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/manage_areas_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/manage_settings_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_detail_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_list_screen.dart';

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
  bool _loading = true;
  String? _error;
  List<AreaItem> _areas = const [];
  List<TableItem> _tables = const [];

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
      final areas = await _repository.getAreas();
      final tables = await _repository.getTables(pageSize: 100);
      if (mounted) {
        setState(() {
          _areas = areas;
          _tables = tables;
        });
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Unable to load dashboard');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  TableItem? get _firstTable => _tables.isEmpty ? null : _tables.first;
  AreaItem? get _firstArea => _areas.isEmpty ? null : _areas.first;

  @override
  Widget build(BuildContext context) {
    final areaCount = _areas.length;
    final tableCount = _tables.length;

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
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin Panel',
                                style: GoogleFonts.manrope(
                                  color: _textColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Facility & Configuration Control',
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _metricCard('AREAS', '$areaCount')),
                        const SizedBox(width: 10),
                        Expanded(child: _metricCard('TABLES', '$tableCount')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        _actionCard(
                          title: 'View Area List',
                          icon: Icons.map,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageAreasScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _actionCard(
                          title: 'View Table Map',
                          icon: Icons.grid_view,
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
                        _actionCard(
                          title: 'View Table Details',
                          icon: Icons.info_outline,
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
                        _actionCard(
                          title: 'Add/Edit Table',
                          icon: Icons.edit_square,
                          onTap: () async {
                            final changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddEditTableScreen(),
                              ),
                            );

                            if (!mounted) {
                              return;
                            }
                            if (changed == true) {
                              _loadSeedData();
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        _actionCard(
                          title: 'Manage Settings',
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
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _metricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F4630)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: _primary,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
