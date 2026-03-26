import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/admin_facility_repository.dart';
import 'package:prm393_booking_app/features/admin/data/admin_media_repository.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/add_edit_table_screen.dart';

class TableDetailScreen extends StatefulWidget {
  final String tableId;
  final String tableName;
  final String? imageUrl;

  const TableDetailScreen({
    super.key,
    required this.tableId,
    required this.tableName,
    this.imageUrl,
  });

  @override
  State<TableDetailScreen> createState() => _TableDetailScreenState();
}

class _TableDetailScreenState extends State<TableDetailScreen> {
  static const Color _primary = Color(0xFF13EC5B);

  final _repository = AdminFacilityRepository();
  final _mediaRepository = AdminMediaRepository();

  bool _loading = true;
  bool _processing = false;
  String? _error;
  TableItem? _table;
  String? _imageUrl;

  int get _tableId => int.tryParse(widget.tableId) ?? 0;

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
      final table = await _repository.getTableById(_tableId);
      final image = await _mediaRepository.getTableImage(_tableId);
      if (!mounted) return;
      setState(() {
        _table = table;
        _imageUrl = image ?? widget.imageUrl;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Unable to load table details');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _edit() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditTableScreen(tableId: widget.tableId, isEditing: true),
      ),
    );

    if (changed == true) {
      await _load();
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _changeStatus(String status) async {
    if (_processing || _table == null) return;
    setState(() => _processing = true);
    try {
      await _repository.changeTableStatus(id: _table!.id, status: status);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $status')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: ${e.message}')),
      );
    } finally {
      if (mounted) {
        setState(() => _processing = false);
      }
    }
  }

  Future<void> _toggleActive() async {
    if (_processing || _table == null) return;
    setState(() => _processing = true);
    try {
      await _repository.toggleTableActive(id: _table!.id, isActive: !_table!.isActive);
      await _load();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: ${e.message}')),
      );
    } finally {
      if (mounted) {
        setState(() => _processing = false);
      }
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
        title: Text(_table?.name ?? widget.tableName),
        actions: [
          TextButton(
            onPressed: _loading || _error != null ? null : _edit,
            child: const Text('Edit'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : _error != null
              ? Center(child: Text(_error!, style: GoogleFonts.manrope(color: text)))
              : _table == null
                  ? Center(
                      child: Text(
                        'Table not found',
                        style: GoogleFonts.manrope(color: muted),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      children: [
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(16),
                            image: _imageUrl == null || _imageUrl!.isEmpty
                                ? null
                                : DecorationImage(
                                    image: NetworkImage(_imageUrl!),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          child: _imageUrl == null || _imageUrl!.isEmpty
                              ? const Center(
                                  child: Icon(
                                    Icons.table_restaurant,
                                    size: 50,
                                    color: _primary,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _infoTile(
                          title: 'Table Name',
                          value: _table!.name,
                          textColor: text,
                          mutedColor: muted,
                          cardColor: card,
                        ),
                        const SizedBox(height: 10),
                        _infoTile(
                          title: 'Area',
                          value: _table!.areaName,
                          textColor: text,
                          mutedColor: muted,
                          cardColor: card,
                        ),
                        const SizedBox(height: 10),
                        _infoTile(
                          title: 'Capacity',
                          value: _table!.capacity.toString(),
                          textColor: text,
                          mutedColor: muted,
                          cardColor: card,
                        ),
                        const SizedBox(height: 10),
                        _infoTile(
                          title: 'Status',
                          value: _table!.status,
                          textColor: text,
                          mutedColor: muted,
                          cardColor: card,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Quick Status',
                          style: GoogleFonts.manrope(
                            color: text,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _statusButton('available'),
                            _statusButton('occupied'),
                            _statusButton('reserved'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _processing ? null : _toggleActive,
                          icon: Icon(
                            _table!.isActive ? Icons.visibility_off : Icons.visibility,
                          ),
                          label: Text(_table!.isActive ? 'Deactivate table' : 'Activate table'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: text,
                            side: BorderSide(color: muted.withOpacity(0.4)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _statusButton(String status) {
    final selected = _table?.status == status;
    return FilledButton.tonal(
      onPressed: _processing ? null : () => _changeStatus(status),
      style: FilledButton.styleFrom(
        backgroundColor: selected ? _primary : null,
        foregroundColor: selected ? const Color(0xFF0B2518) : null,
      ),
      child: Text(status.toUpperCase()),
    );
  }

  Widget _infoTile({
    required String title,
    required String value,
    required Color textColor,
    required Color mutedColor,
    required Color cardColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                color: mutedColor,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
