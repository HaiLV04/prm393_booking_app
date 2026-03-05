import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String _selectedFilter = 'all';

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _surfaceDark = Color(0xFF1C271F);
  static const Color _textSecondary = Color(0xFF9DB9A6);

  final List<Map<String, dynamic>> _tables = [
    {
      'id': '01',
      'name': 'Table 01',
      'status': 'available',
      'seats': 4,
      'icon': Icons.table_restaurant,
    },
    {
      'id': '02',
      'name': 'Table 02',
      'status': 'occupied',
      'seats': 2,
      'icon': Icons.restaurant,
      'occupiedSince': '7:30 PM',
      'duration': '45m',
    },
    {
      'id': '03',
      'name': 'Table 03',
      'status': 'reserved',
      'seats': 6,
      'icon': Icons.event_seat,
      'reservationTime': '8:30 PM',
      'customerName': 'John D.',
    },
    {
      'id': '04',
      'name': 'Table 04',
      'status': 'available',
      'seats': 2,
      'icon': Icons.table_restaurant,
    },
    {
      'id': '05',
      'name': 'Table 05',
      'status': 'occupied',
      'seats': 4,
      'icon': Icons.restaurant,
      'occupiedSince': '8:00 PM',
      'duration': '15m',
    },
    {
      'id': '06',
      'name': 'Table 06',
      'status': 'available',
      'seats': 8,
      'icon': Icons.table_restaurant,
    },
    {
      'id': '07',
      'name': 'Table 07',
      'status': 'closed',
      'seats': 4,
      'icon': Icons.build,
    },
  ];

  List<Map<String, dynamic>> get _filteredTables {
    if (_selectedFilter == 'all') return _tables;
    return _tables.where((t) => t['status'] == _selectedFilter).toList();
  }

  int get _countByStatus {
    if (_selectedFilter == 'all') return _tables.length;
    return _filteredTables.length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _bgDark : const Color(0xFFF6F8F6);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? _textSecondary : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(textColor, isDark),
            // Filter Buttons
            _buildFilterButtons(isDark, textColor, subtitleColor),
            // Table Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                      children: [
                        ..._buildTableCards(textColor, subtitleColor, isDark),
                        _buildAddTableButton(isDark, textColor),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildHeader(Color textColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.areaName,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons(
    bool isDark,
    Color textColor,
    Color subtitleColor,
  ) {
    final filters = [
      {'id': 'all', 'label': 'All', 'count': _tables.length},
      {'id': 'available', 'label': 'Available', 'color': Colors.green.shade500},
      {'id': 'occupied', 'label': 'Occupied', 'color': Colors.red.shade500},
      {'id': 'reserved', 'label': 'Reserved', 'color': Colors.yellow.shade500},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(filters.length, (index) {
          final filter = filters[index];
          final isActive = _selectedFilter == filter['id'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () =>
                  setState(() => _selectedFilter = filter['id'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? (isDark ? _primary : Colors.black87)
                      : (isDark ? _surfaceDark : Colors.white),
                  border: Border.all(
                    color: isDark
                        ? (isActive ? _primary : const Color(0xFF28392E))
                        : (isActive ? Colors.black87 : const Color(0xFFE2E8F0)),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (filter['id'] != 'all')
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: filter['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    Text(
                      filter['label'] as String,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? (isDark ? _bgDark : Colors.white)
                            : subtitleColor,
                      ),
                    ),
                    if (filter['id'] == 'all')
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (isActive
                                ? Colors.white.withOpacity(0.2)
                                : const Color(0xFFF3F4F6)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_countByStatus}',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isActive ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildTableCards(
    Color textColor,
    Color subtitleColor,
    bool isDark,
  ) {
    return _filteredTables.map((table) {
      Color statusColor;
      Color statusBgColor;
      Color statusTextColor;
      IconData statusIcon;

      switch (table['status']) {
        case 'available':
          statusColor = Colors.green.shade500;
          statusBgColor = Colors.green.shade100;
          statusTextColor = Colors.green.shade700;
          statusIcon = Icons.table_restaurant;
          break;
        case 'occupied':
          statusColor = Colors.red.shade500;
          statusBgColor = Colors.red.shade100;
          statusTextColor = Colors.red.shade700;
          statusIcon = Icons.restaurant;
          break;
        case 'reserved':
          statusColor = Colors.yellow.shade500;
          statusBgColor = Colors.yellow.shade100;
          statusTextColor = Colors.yellow.shade700;
          statusIcon = Icons.event_seat;
          break;
        case 'closed':
          statusColor = Colors.grey.shade600;
          statusBgColor = Colors.grey.shade200;
          statusTextColor = Colors.grey.shade700;
          statusIcon = Icons.build;
          break;
        default:
          statusColor = Colors.grey.shade500;
          statusBgColor = Colors.grey.shade100;
          statusTextColor = Colors.grey.shade700;
          statusIcon = Icons.help_outline;
      }

      final isGrayscale = table['status'] == 'closed';

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TableDetailScreen(
                tableId: table['id'],
                tableName: table['name'],
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? _surfaceDark
                : (isGrayscale ? Colors.grey.shade50 : Colors.white),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF28392E)
                  : (isGrayscale
                        ? const Color(0xFFE5E7EB)
                        : Colors.grey.shade300),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Opacity(
            opacity: isGrayscale ? 0.7 : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? statusColor.withOpacity(0.15)
                              : statusBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          statusIcon,
                          color: isDark ? statusColor : statusTextColor,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? statusColor.withOpacity(0.15)
                              : statusBgColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          table['status'].toString().toUpperCase(),
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? statusColor : statusTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Table Name
                  Text(
                    table['name'],
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Seats
                  Row(
                    children: [
                      Icon(Icons.group, size: 16, color: subtitleColor),
                      const SizedBox(width: 4),
                      Text(
                        '${table['seats']} Seats',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                  // Additional Info
                  if (table['status'] == 'occupied')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey.shade200,
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Since ${table['occupiedSince']}',
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Text(
                                table['duration'],
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (table['status'] == 'reserved')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey.shade200,
                            height: 12,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: Colors.yellow.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${table['reservationTime']} (${table['customerName']})',
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  color: Colors.yellow.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildAddTableButton(bool isDark, Color textColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditTableScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.transparent : Colors.transparent,
          border: Border.all(
            color: isDark ? const Color(0xFF28392E) : const Color(0xFFD1D5DB),
            strokeAlign: BorderSide.strokeAlignCenter,
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditTableScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, color: _primary, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add Table',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: _primary,
      elevation: 8,
      child: const Icon(Icons.add_location, color: Color(0xFF102216), size: 28),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    final navItems = [
      {
        'icon': Icons.table_restaurant,
        'label': 'Tables',
        'index': 0,
        'active': true,
      },
      {'icon': Icons.calendar_today, 'label': 'Reservations', 'index': 1},
      {'icon': Icons.receipt_long, 'label': 'Orders', 'index': 2},
      {'icon': Icons.settings, 'label': 'Settings', 'index': 3},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? _surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF28392E) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isActive =
              item['index'] == 0 && (item['active'] as bool? ?? false);

          return GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: isActive ? _primary : _textSecondary,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? _primary : _textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
