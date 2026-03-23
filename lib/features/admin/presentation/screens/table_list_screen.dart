import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/admin_facility_repository.dart';
import 'package:prm393_booking_app/features/admin/data/admin_media_repository.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/add_edit_table_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_detail_screen.dart';

class TableListScreen extends StatefulWidget {
  final String areaName;
  final String? areaId;

  const TableListScreen({super.key, required this.areaName, this.areaId});

  @override
  State<TableListScreen> createState() => _TableListScreenState();
}

class _TableListScreenState extends State<TableListScreen> {
  static const Color _primary = Color(0xFF13EC5B);

  final _repository = AdminFacilityRepository();
  final _mediaRepository = AdminMediaRepository();

  bool _loading = true;
  String? _error;
  String _statusFilter = 'all';
  List<TableItem> _tables = const [];
  Map<int, String> _tableImages = const {};

  int? get _areaId => int.tryParse(widget.areaId ?? '');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final status = _statusFilter == 'all' ? null : _statusFilter;
      final tables = await _repository.getTables(areaId: _areaId, status: status);
      final images = await _mediaRepository.getTableImages();
      if (!mounted) return;
      setState(() {
        _tables = tables;
        _tableImages = images;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Unable to load tables');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _openAddTable() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTableScreen()),
    );
    if (changed == true) {
      await _load();
    }
  }

  Future<void> _openDetail(TableItem table) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TableDetailScreen(
          tableId: table.id.toString(),
          tableName: table.name,
          imageUrl: _tableImages[table.id],
        ),
      ),
    );
    if (changed == true) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0B2518) : const Color(0xFFF0F5F2);
    final card = isDark ? const Color(0xFF143523) : Colors.white;
    final text = isDark ? Colors.white : const Color(0xFF102216);
    final muted = isDark ? const Color(0xFFA0B9AA) : const Color(0xFF6B8074);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: text,
        title: Text(widget.areaName),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _primary,
        foregroundColor: const Color(0xFF0B2518),
        onPressed: _openAddTable,
        icon: const Icon(Icons.add),
        label: const Text('Add Table'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                _filterChip('all', 'All'),
                const SizedBox(width: 8),
                _filterChip('available', 'Available'),
                const SizedBox(width: 8),
                _filterChip('occupied', 'Occupied'),
                const SizedBox(width: 8),
                _filterChip('reserved', 'Reserved'),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _primary))
                : _error != null
                    ? Center(child: Text(_error!, style: GoogleFonts.manrope(color: text)))
                    : _tables.isEmpty
                        ? Center(
                            child: Text(
                              'No tables found',
                              style: GoogleFonts.manrope(color: muted),
                            ),
                          )
                        : RefreshIndicator(
                            color: _primary,
                            onRefresh: _load,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                              itemCount: _tables.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 10),
                              itemBuilder: (_, index) {
                                final table = _tables[index];
                                final statusColor = _statusColor(table.status);
                                final image = _tableImages[table.id];

                                return InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => _openDetail(table),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: card,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: statusColor.withOpacity(0.35),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 92,
                                          height: 92,
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: image == null || image.isEmpty
                                                ? null
                                                : DecorationImage(
                                                    image: NetworkImage(image),
                                                    fit: BoxFit.cover,
                                                  ),
                                            color: isDark
                                                ? const Color(0xFF1A4430)
                                                : const Color(0xFFE9F2EC),
                                          ),
                                          child: image == null || image.isEmpty
                                              ? Icon(
                                                  Icons.table_restaurant,
                                                  color: statusColor,
                                                )
                                              : null,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 12,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  table.name,
                                                  style: GoogleFonts.manrope(
                                                    color: text,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Capacity ${table.capacity} • ${table.areaName}',
                                                  style: GoogleFonts.manrope(
                                                    color: muted,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: statusColor.withOpacity(
                                                      0.14,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(999),
                                                  ),
                                                  child: Text(
                                                    table.status.toUpperCase(),
                                                    style: GoogleFonts.manrope(
                                                      color: statusColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _openDetail(table),
                                          icon: Icon(
                                            Icons.chevron_right,
                                            color: muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String value, String label) {
    final selected = _statusFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (v) async {
        if (!v) return;
        setState(() => _statusFilter = value);
        await _load();
      },
      selectedColor: _primary,
      labelStyle: GoogleFonts.manrope(
        color: selected ? const Color(0xFF0B2518) : null,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return const Color(0xFF0BBF5F);
      case 'occupied':
        return const Color(0xFFE05555);
      case 'reserved':
        return const Color(0xFFE3A400);
      default:
        return const Color(0xFF6B8074);
    }
  }
}
