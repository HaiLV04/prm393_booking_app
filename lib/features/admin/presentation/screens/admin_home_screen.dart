import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/add_edit_table_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_detail_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/manage_areas_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedTab = 0;

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _surfaceDark = Color(0xFF1C2E23);

  final List<String> _tabLabels = ['Dashboard', 'Tables', 'Bookings', 'Menu'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _bgDark : const Color(0xFFF6F8F6);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          'Admin Panel',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: textColor),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: bgColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: List.generate(
                _tabLabels.length,
                (index) => Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == index
                                ? _primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tabLabels[index],
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: _selectedTab == index
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _selectedTab == index
                              ? _primary
                              : subtitleColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFE2E8F0),
          ),

          // Tab Content
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildDashboardTab(textColor, subtitleColor, isDark),
                _buildTablesTab(textColor, subtitleColor, isDark),
                _buildBookingsTab(textColor, subtitleColor, isDark),
                _buildMenuTab(textColor, subtitleColor, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab(Color textColor, Color subtitleColor, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard(
            'Total Bookings',
            '24',
            Icons.calendar_today,
            _primary,
            textColor,
            subtitleColor,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'Available Tables',
            '18/25',
            Icons.table_chart,
            const Color(0xFF0EA5E9),
            textColor,
            subtitleColor,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'Revenue Today',
            '\$2,450',
            Icons.attach_money,
            const Color(0xFFF59E0B),
            textColor,
            subtitleColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Quick Actions',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildQuickActionButton('Add New Table', Icons.add, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditTableScreen()),
            );
          }),
          const SizedBox(height: 8),
          _buildQuickActionButton('Manage Areas', Icons.map, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageAreasScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTablesTab(Color textColor, Color subtitleColor, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditTableScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: Text(
              'Add New Table',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: _bgDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Available Tables (18)',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildTableList(textColor, subtitleColor, isDark),
        ],
      ),
    );
  }

  Widget _buildBookingsTab(Color textColor, Color subtitleColor, bool isDark) {
    return Center(
      child: Text(
        'Bookings Management Coming Soon',
        style: GoogleFonts.manrope(color: subtitleColor),
      ),
    );
  }

  Widget _buildMenuTab(Color textColor, Color subtitleColor, bool isDark) {
    return Center(
      child: Text(
        'Menu Management Coming Soon',
        style: GoogleFonts.manrope(color: subtitleColor),
      ),
    );
  }

  List<Widget> _buildTableList(
    Color textColor,
    Color subtitleColor,
    bool isDark,
  ) {
    final tables = [
      {
        'name': 'Table 01',
        'capacity': '4',
        'area': 'Main Hall',
        'status': 'Available',
      },
      {
        'name': 'Table 02',
        'capacity': '6',
        'area': 'Main Hall',
        'status': 'Reserved',
      },
      {
        'name': 'Table 03',
        'capacity': '2',
        'area': 'Bar',
        'status': 'Available',
      },
      {
        'name': 'Table 04',
        'capacity': '8',
        'area': 'Private Room',
        'status': 'Blocked',
      },
    ];

    return tables.map((table) {
      final isAvailable = table['status'] == 'Available';
      final isReserved = table['status'] == 'Reserved';
      final statusColor = isAvailable
          ? _primary
          : isReserved
          ? const Color(0xFFF59E0B)
          : const Color(0xFFEF4444);

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TableDetailScreen(
                  tableId: table['name']!.replaceAll(' ', '_'),
                  tableName: table['name']!,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? _surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        table['name']!,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${table['capacity']} seats • ${table['area']}',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    table['status']!,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(child: Text('Edit')),
                    const PopupMenuItem(child: Text('Delete')),
                  ],
                  child: Icon(Icons.more_vert, color: subtitleColor, size: 20),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color textColor,
    Color subtitleColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? _surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : const Color(0xFFE2E8F0),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? _surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: _primary),
        title: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward, color: _primary, size: 18),
        onTap: onPressed,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.manrope(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.manrope(color: const Color(0xFF64748B)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Logout', style: GoogleFonts.manrope(color: _primary)),
          ),
        ],
      ),
    );
  }
}
