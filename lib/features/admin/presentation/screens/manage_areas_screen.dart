import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/admin_facility_repository.dart';
import 'package:prm393_booking_app/features/admin/data/admin_media_repository.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_list_screen.dart';

class ManageAreasScreen extends StatefulWidget {
  const ManageAreasScreen({super.key});

  @override
  State<ManageAreasScreen> createState() => _ManageAreasScreenState();
}

class _ManageAreasScreenState extends State<ManageAreasScreen> {
  static const Color _primary = Color(0xFF13EC5B);

  final _repository = AdminFacilityRepository();
  final _mediaRepository = AdminMediaRepository();
  final _searchController = TextEditingController();

  bool _loading = true;
  bool _processing = false;
  String? _error;
  String _keyword = '';
  List<AreaItem> _areas = const [];
  Map<int, String> _areaImages = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final areas = await _repository.getAreas();
      final images = await _mediaRepository.getAreaImages();
      if (!mounted) return;
      setState(() {
        _areas = areas;
        _areaImages = images;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Unable to load areas');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<AreaItem> get _filteredAreas {
    if (_keyword.trim().isEmpty) {
      return _areas;
    }
    final key = _keyword.trim().toLowerCase();
    return _areas.where((a) {
      return a.name.toLowerCase().contains(key) ||
          a.description.toLowerCase().contains(key);
    }).toList();
  }

  Future<void> _openCreateDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Create New Area'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Area name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (created != true) {
      return;
    }

    final name = nameController.text.trim();
    final desc = descController.text.trim();
    if (name.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Area name is required')),
        );
      }
      return;
    }

    setState(() => _processing = true);
    try {
      await _repository.createArea(name: name, description: desc);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Area created successfully')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Create failed: ${e.message}')),
      );
    } finally {
      if (mounted) {
        setState(() => _processing = false);
      }
    }
  }

  Future<void> _openEditDialog(AreaItem area) async {
    final nameController = TextEditingController(text: area.name);
    final descController = TextEditingController(text: area.description);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Area'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Area name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final name = nameController.text.trim();
    final desc = descController.text.trim();
    if (name.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Area name is required')),
        );
      }
      return;
    }

    setState(() => _processing = true);
    try {
      await _repository.updateArea(id: area.id, name: name, description: desc);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Area updated successfully')),
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

  Future<void> _toggleActive(AreaItem area) async {
    if (_processing) return;
    setState(() => _processing = true);
    try {
      await _repository.toggleAreaActive(id: area.id, isActive: !area.isActive);
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
        title: const Text('Manage Areas'),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _processing ? null : _openCreateDialog,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _primary,
        foregroundColor: const Color(0xFF0B2518),
        onPressed: _processing ? null : _openCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('Create New Area'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _keyword = v),
              style: GoogleFonts.manrope(color: text),
              decoration: InputDecoration(
                hintText: 'Search areas...',
                hintStyle: GoogleFonts.manrope(color: muted),
                prefixIcon: Icon(Icons.search, color: muted),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _primary))
                : _error != null
                    ? Center(child: Text(_error!, style: GoogleFonts.manrope(color: text)))
                    : _filteredAreas.isEmpty
                        ? Center(
                            child: Text(
                              'No areas found',
                              style: GoogleFonts.manrope(color: muted),
                            ),
                          )
                        : RefreshIndicator(
                            color: _primary,
                            onRefresh: _load,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                              itemCount: _filteredAreas.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 10),
                              itemBuilder: (_, index) {
                                final area = _filteredAreas[index];
                                final image = _areaImages[area.id];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: card,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: area.isActive
                                          ? _primary.withOpacity(0.25)
                                          : muted.withOpacity(0.25),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 140,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(14),
                                          ),
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
                                                Icons.map_outlined,
                                                size: 34,
                                                color: area.isActive ? _primary : muted,
                                              )
                                            : null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    area.name,
                                                    style: GoogleFonts.manrope(
                                                      color: text,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: area.isActive
                                                        ? _primary.withOpacity(0.14)
                                                        : muted.withOpacity(0.14),
                                                    borderRadius:
                                                        BorderRadius.circular(999),
                                                  ),
                                                  child: Text(
                                                    area.isActive ? 'ACTIVE' : 'INACTIVE',
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w700,
                                                      color:
                                                          area.isActive ? _primary : muted,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              area.description.isEmpty
                                                  ? 'No description'
                                                  : area.description,
                                              style: GoogleFonts.manrope(
                                                color: muted,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: _processing
                                                        ? null
                                                        : () => _openEditDialog(area),
                                                    child: const Text('Edit'),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: FilledButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => TableListScreen(
                                                            areaName: area.name,
                                                            areaId: area.id.toString(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    style: FilledButton.styleFrom(
                                                      backgroundColor: _primary,
                                                      foregroundColor:
                                                          const Color(0xFF0B2518),
                                                    ),
                                                    child: const Text('Tables'),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                IconButton(
                                                  onPressed: _processing
                                                      ? null
                                                      : () => _toggleActive(area),
                                                  icon: Icon(
                                                    area.isActive
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                    color: muted,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
}
