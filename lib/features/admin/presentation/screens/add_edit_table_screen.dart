import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/admin_facility_repository.dart';
import 'package:prm393_booking_app/features/admin/data/admin_media_repository.dart';

class AddEditTableScreen extends StatefulWidget {
  final String? tableId;
  final bool isEditing;

  const AddEditTableScreen({super.key, this.tableId, this.isEditing = false});

  @override
  State<AddEditTableScreen> createState() => _AddEditTableScreenState();
}

class _AddEditTableScreenState extends State<AddEditTableScreen> {
  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bg = Color(0xFF0B2518);
  static const Color _card = Color(0xFF143523);
  static const Color _muted = Color(0xFFA0B9AA);

  final _formKey = GlobalKey<FormState>();
  final _tableNameController = TextEditingController();
  final _capacityController = TextEditingController(text: '4');
  final _imageUrlController = TextEditingController();
  final _repository = AdminFacilityRepository();
  final _mediaRepository = AdminMediaRepository();

  bool _loading = true;
  bool _saving = false;
  String? _error;

  int? _selectedAreaId;
  String _selectedStatus = 'available';
  List<AreaItem> _areas = const [];

  int? get _tableId => int.tryParse(widget.tableId ?? '');

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _tableNameController.dispose();
    _capacityController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      _areas = (await _repository.getAreas()).where((x) => x.isActive).toList();

      if (widget.isEditing && _tableId != null && _tableId! > 0) {
        final table = await _repository.getTableById(_tableId!);
        _tableNameController.text = table.name;
        _capacityController.text = table.capacity.toString();
        _selectedStatus = table.status;
        _selectedAreaId = table.areaId;
        _imageUrlController.text =
            await _mediaRepository.getTableImage(table.id) ?? '';
      } else if (_areas.isNotEmpty) {
        _selectedAreaId = _areas.first.id;
      }
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Unable to load table data';
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final areaId = _selectedAreaId;
    final capacity = int.tryParse(_capacityController.text.trim());
    if (areaId == null || capacity == null) {
      return;
    }

    setState(() => _saving = true);

    try {
      int tableId = _tableId ?? 0;
      if (widget.isEditing && _tableId != null && _tableId! > 0) {
        await _repository.updateTable(
          id: _tableId!,
          areaId: areaId,
          name: _tableNameController.text.trim(),
          capacity: capacity,
          status: _selectedStatus,
        );
      } else {
        final created = await _repository.createTable(
          areaId: areaId,
          name: _tableNameController.text.trim(),
          capacity: capacity,
          status: _selectedStatus,
        );
        tableId = created.id;
      }

      if (tableId > 0) {
        await _mediaRepository.setTableImage(
          tableId,
          _imageUrlController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditing ? 'Edit Table' : 'Add Table';

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        title: Text(
          title,
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 30,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: GoogleFonts.manrope(color: Colors.white),
                  ),
                )
              : SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isEditing
                                      ? 'Update table info and status'
                                      : 'Create a new table for your floor plan',
                                  style: GoogleFonts.manrope(
                                    color: _muted,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: _card,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF1E4A34),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _label('Table Name'),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _tableNameController,
                                        style: _fieldTextStyle(),
                                        decoration: _inputDecoration(
                                          hint: 'e.g. Table A1',
                                        ),
                                        validator: (v) =>
                                            v == null || v.trim().isEmpty
                                                ? 'Required'
                                                : null,
                                      ),
                                      const SizedBox(height: 12),
                                      _label('Capacity'),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _capacityController,
                                        keyboardType: TextInputType.number,
                                        style: _fieldTextStyle(),
                                        decoration: _inputDecoration(
                                          hint: 'Number of seats',
                                        ),
                                        validator: (v) {
                                          final n = int.tryParse(v ?? '');
                                          if (n == null || n < 1 || n > 100) {
                                            return 'Capacity 1-100';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      _label('Area'),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<int>(
                                        initialValue: _selectedAreaId,
                                        isExpanded: true,
                                        style: _fieldTextStyle(),
                                        dropdownColor: const Color(0xFFF4F7F5),
                                        decoration: _inputDecoration(
                                          hint: 'Select area',
                                        ),
                                        items: _areas
                                            .map(
                                              (a) => DropdownMenuItem<int>(
                                                value: a.id,
                                                child: Text(
                                                  a.name,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.manrope(
                                                    color: const Color(0xFF163325),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) =>
                                            setState(() => _selectedAreaId = v),
                                        validator: (v) =>
                                            v == null ? 'Select area' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      _label('Status'),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        initialValue: _selectedStatus,
                                        isExpanded: true,
                                        style: _fieldTextStyle(),
                                        dropdownColor: const Color(0xFFF4F7F5),
                                        decoration: _inputDecoration(
                                          hint: 'Select status',
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'available',
                                            child: Text('Available'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'occupied',
                                            child: Text('Occupied'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'reserved',
                                            child: Text('Reserved'),
                                          ),
                                        ],
                                        onChanged: (v) {
                                          if (v != null) {
                                            setState(() => _selectedStatus = v);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _card,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              _imageUrlController.text.isEmpty
                                                  ? Icons.image_not_supported
                                                  : Icons.check_circle,
                                              color: _imageUrlController.text.isEmpty
                                                  ? _muted
                                                  : _primary,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                _imageUrlController.text.isEmpty
                                                    ? 'No image selected'
                                                    : 'Image selected successfully',
                                                style: GoogleFonts.manrope(
                                                  color: _muted,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final picker = ImagePicker();
                                          final file = await picker.pickImage(
                                            source: ImageSource.gallery,
                                            maxWidth: 600,
                                            maxHeight: 600,
                                            imageQuality: 60,
                                          );
                                          if (file != null) {
                                            final bytes = await file.readAsBytes();
                                            final b64 = base64Encode(bytes);
                                            final mime = file.mimeType ?? 'image/jpeg';
                                            setState(() {
                                              _imageUrlController.text =
                                                  'data:$mime;base64,$b64';
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.upload, color: _primary),
                                      ),
                                      if (_imageUrlController.text.isNotEmpty)
                                        IconButton(
                                          onPressed: () =>
                                              setState(() => _imageUrlController.clear()),
                                          icon: const Icon(
                                            Icons.clear,
                                            color: Colors.orange,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                        decoration: BoxDecoration(
                          color: _bg,
                          border: Border(
                            top: BorderSide(
                              color: const Color(0xFF1E4A34).withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        child: SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: _saving ? null : _save,
                            style: FilledButton.styleFrom(
                              backgroundColor: _primary,
                              foregroundColor: const Color(0xFF0B2518),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: Text(
                              _saving ? 'Saving...' : (widget.isEditing ? 'Update Table' : 'Create Table'),
                              style: GoogleFonts.manrope(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  TextStyle _fieldTextStyle() {
    return GoogleFonts.manrope(
      color: const Color(0xFF163325),
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFD5E3DA)),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(
        color: const Color(0xFF72887C),
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xFFF4F7F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: _primary, width: 1.6),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: Color(0xFFE85D5D), width: 1.3),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        color: const Color(0xFFB7D0C2),
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
    );
  }
}
