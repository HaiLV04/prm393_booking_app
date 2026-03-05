import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEditTableScreen extends StatefulWidget {
  final String? tableId;
  final bool isEditing;

  const AddEditTableScreen({super.key, this.tableId, this.isEditing = false});

  @override
  State<AddEditTableScreen> createState() => _AddEditTableScreenState();
}

class _AddEditTableScreenState extends State<AddEditTableScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tableNameController = TextEditingController();
  final _capacityController = TextEditingController();

  String _selectedStatus = 'available';
  String? _selectedArea;

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgLight = Color(0xFFF6F8F6);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _surfaceDark = Color(0xFF1C2E23);

  final List<Map<String, String>> _areas = [
    {'id': 'main_hall', 'name': 'Main Dining Hall'},
    {'id': 'patio', 'name': 'Outdoor Patio'},
    {'id': 'bar', 'name': 'Bar Area'},
    {'id': 'private', 'name': 'Private Room A'},
  ];

  @override
  void dispose() {
    _tableNameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _bgDark : _bgLight;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final inputBg = isDark ? _surfaceDark : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2A4230)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEditing ? 'Edit Table' : 'Add Table',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveTable,
            child: Text(
              'Save',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table Details Section
                _buildSectionTitle('Table Details', textColor),
                const SizedBox(height: 16),
                _buildTableNameInput(
                  textColor,
                  subtitleColor,
                  inputBg,
                  borderColor,
                ),
                const SizedBox(height: 16),
                _buildCapacityInput(
                  textColor,
                  subtitleColor,
                  inputBg,
                  borderColor,
                ),
                const SizedBox(height: 16),
                _buildStatusSelector(textColor, subtitleColor),
                const SizedBox(height: 24),
                Divider(color: borderColor),
                const SizedBox(height: 24),

                // Location Assignment Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle('Location Assignment', textColor),
                    TextButton(
                      onPressed: () {
                        // Navigate to manage areas
                      },
                      child: Text(
                        'Manage Areas',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAreaDropdown(
                  textColor,
                  subtitleColor,
                  inputBg,
                  borderColor,
                ),
                const SizedBox(height: 20),
                _buildMapSelector(isDark),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _saveTable,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.save, color: Color(0xFF102216), size: 20),
              const SizedBox(width: 8),
              Text(
                'Save Table',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF102216),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }

  Widget _buildTableNameInput(
    Color textColor,
    Color subtitleColor,
    Color inputBg,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Table Name or Number',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
        ),
        TextFormField(
          controller: _tableNameController,
          style: GoogleFonts.manrope(color: textColor),
          decoration: InputDecoration(
            hintText: 'e.g. Table 12 or T-12',
            hintStyle: GoogleFonts.manrope(color: subtitleColor),
            filled: true,
            fillColor: inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter table name or number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCapacityInput(
    Color textColor,
    Color subtitleColor,
    Color inputBg,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Seating Capacity',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
        ),
        TextFormField(
          controller: _capacityController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.manrope(color: textColor),
          decoration: InputDecoration(
            hintText: 'e.g. 4',
            hintStyle: GoogleFonts.manrope(color: subtitleColor),
            filled: true,
            fillColor: inputBg,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.group, color: subtitleColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter seating capacity';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStatusSelector(Color textColor, Color subtitleColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputBg = isDark ? _surfaceDark : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Initial Status',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _buildStatusButton('available', 'Available', textColor),
              _buildStatusButton('reserved', 'Reserved', textColor),
              _buildStatusButton('blocked', 'Blocked', textColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String value, String label, Color textColor) {
    final isSelected = _selectedStatus == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedStatus = value),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? _primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF102216)
                  : textColor.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAreaDropdown(
    Color textColor,
    Color subtitleColor,
    Color inputBg,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Assign Area',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedArea,
          hint: Text(
            'Select an area',
            style: GoogleFonts.manrope(color: subtitleColor),
          ),
          style: GoogleFonts.manrope(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: _areas
              .map(
                (area) => DropdownMenuItem(
                  value: area['id'],
                  child: Text(area['name']!),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedArea = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an area';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMapSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Pin Location on Map',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Map feature coming soon',
                  style: GoogleFonts.manrope(),
                ),
              ),
            );
          },
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : const Color(0xFFE2E8F0),
              ),
              color: _surfaceDark,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: _primary, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to set position',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the map to precisely position this table in the floor plan.',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  void _saveTable() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Table saved successfully',
            style: GoogleFonts.manrope(),
          ),
          backgroundColor: _primary,
        ),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
    }
  }
}
