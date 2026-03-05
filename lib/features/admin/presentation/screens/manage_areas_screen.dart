import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_list_screen.dart';

class ManageAreasScreen extends StatefulWidget {
  const ManageAreasScreen({super.key});

  @override
  State<ManageAreasScreen> createState() => _ManageAreasScreenState();
}

class _ManageAreasScreenState extends State<ManageAreasScreen> {
  int _selectedNavTab = 0; // Tables is active
  final _searchController = TextEditingController();

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _surfaceDark = Color(0xFF162E1E);
  static const Color _mutedDark = Color(0xFF9DB9A6);

  final List<Map<String, dynamic>> _areas = [
    {
      'name': 'Main Indoor Hall',
      'status': 'Open',
      'tables': 40,
      'capacity': 120,
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA4LJLA4Y1e4qMoEyuQPapc3CgfiT0EqG2tVZyYr5HGeGzpdLikry1mxYcpUp3qGQPEGAONy83iuNyeXNBoJya-ZVbiojELzNUq7pc3RV26DgA92o4CrARMFCPpzhzJ5PMFs9JCYsQM-O9dKsQp-H3XuYeKxz_6QCDFSLp7a7_Y1uyknXBPITxHb6Ug5mgTuCWyCWeDWxRvW4VQbxSoqmIAWfBHhZVr1pXdpELjzMSUbJrapetEd07nzDfdKbS7OnWgNGueBVUckbs',
    },
    {
      'name': 'Terrace Garden',
      'status': 'Open',
      'tables': 15,
      'capacity': 45,
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCT5Hg4fZxX6Vfh3zhGPuuqMj_v6AXOqCXOR-nkPFEnUn76gQMvOFACbb71FSXdQlsLkbpTuIgD4jTOlHgKsuaUs2hZWwQ8EvEjqdFnQbqvoD7TakjsRtBpQJTQq364M0srPSzvpz-2mJP5-VCXHrMBu3NrxE1pEG7OdZZbSXbK-jF18_K1fXfHOtRstxhZ1aacHBDwuWK7FPX6XM6Yi3M3ppMv_zOyeBxhfWhKW6x4TUb0ZZvFtlxC9MzmHTqGiCjaVJjtdOqOPIU',
    },
    {
      'name': 'VIP Lounge',
      'status': 'Reserved',
      'tables': 8,
      'capacity': 24,
      'isVip': true,
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAsZRL1L2qNp7h-ze9fl-uXh2Ws_LuXym-uqmbZlCbofLtoUEm5zveAXxnLKbJlnsHBXFnKu3UvN6nZwTERk7Ig2Ux6VrUtxXK102BmtjE0PsloMlOAwqHQYKrWhO3YH6gdDvFmL_ZqrsL6KYDlUWUimANQ1xwml5dmJdRPId-P0S327_CfGqWn3nYEqUNO4rSrhKVgdhsfEzvkZbHTtQTOfIUtlUan80SJ_qnoE_OdGcFOVmI9z1qjEmstsqfBbG5rFW2H9w3ZDDU',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _bgDark : const Color(0xFFF6F8F6);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? _mutedDark : const Color(0xFF64748B);
    final surfaceColor = isDark ? _surfaceDark : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(textColor, isDark),
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Search
                      _buildSearchBar(isDark, textColor, subtitleColor),
                      const SizedBox(height: 24),
                      // Stats
                      _buildStatsGrid(surfaceColor, textColor, subtitleColor),
                      const SizedBox(height: 24),
                      // Areas Title
                      Text(
                        'Restaurant Zones',
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Area Cards
                      ..._buildAreaCards(
                        surfaceColor,
                        textColor,
                        subtitleColor,
                      ),
                      const SizedBox(height: 16),
                      // Create New Area Button
                      _buildCreateNewAreaButton(isDark, textColor),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Navigation
            _buildBottomNav(isDark),
          ],
        ),
      ),
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
              'Manage Areas',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.add, color: _primary, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, Color textColor, Color subtitleColor) {
    return TextField(
      controller: _searchController,
      style: GoogleFonts.manrope(color: textColor),
      decoration: InputDecoration(
        hintText: 'Search zones...',
        hintStyle: GoogleFonts.manrope(color: subtitleColor),
        prefixIcon: Icon(Icons.search, color: subtitleColor),
        filled: true,
        fillColor: isDark ? _surfaceDark : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildStatsGrid(
    Color surfaceColor,
    Color textColor,
    Color subtitleColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Capacity',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '68',
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'tables',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Zones',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '3',
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'areas',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAreaCards(
    Color surfaceColor,
    Color textColor,
    Color subtitleColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _areas.map((area) {
      final isVip = area['isVip'] ?? false;
      final statusColor = area['status'] == 'Open'
          ? Colors.green.shade500
          : Colors.grey.shade700;

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(area['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Status Badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: area['status'] == 'Open'
                              ? Colors.green.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          area['status'],
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ),
                    // Name
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              area['name'],
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (isVip)
                            Icon(
                              Icons.star,
                              color: Colors.yellow.shade400,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.table_restaurant,
                                color: _primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${area['tables']} Tables',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.group, color: _primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${area['capacity']} Guests',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.1), height: 1),
                      const SizedBox(height: 16),
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : const Color(0xFFE2E8F0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Details',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TableListScreen(
                                      areaName: area['name'] as String,
                                      areaId: area['name']
                                          .toString()
                                          .replaceAll(' ', '_')
                                          .toLowerCase(),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.grid_view, size: 18),
                              label: Text(
                                'Layout',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: _bgDark,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
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
      );
    }).toList();
  }

  Widget _buildCreateNewAreaButton(bool isDark, Color textColor) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : const Color(0xFFCBD5E1),
          strokeAlign: BorderSide.strokeAlignCenter,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle, color: _primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Create New Area',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    final navItems = [
      {'icon': Icons.table_restaurant, 'label': 'Tables', 'index': 0},
      {'icon': Icons.calendar_today, 'label': 'Bookings', 'index': 1},
      {'icon': Icons.receipt_long, 'label': 'Orders', 'index': 2},
      {'icon': Icons.settings, 'label': 'Settings', 'index': 3},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? _bgDark.withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isActive = _selectedNavTab == item['index'];

          return GestureDetector(
            onTap: () => setState(() => _selectedNavTab = item['index'] as int),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive
                        ? _primary.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: isActive ? _primary : const Color(0xFF9DB9A6),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? _primary : const Color(0xFF9DB9A6),
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
