import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int _selectedNavTab = 2; // Tables is active

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _surfaceDark = Color(0xFF1C2E21);
  static const Color _textSecondary = Color(0xFF9DB9A6);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _bgDark : const Color(0xFFF6F8F6);
    final textColor = isDark
        ? const Color(0xFFE2E8E4)
        : const Color(0xFF0F172A);
    final subtitleColor = isDark ? _textSecondary : const Color(0xFF64748B);

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
                child: Column(
                  children: [
                    _buildHeroImage(isDark),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quick Stats
                          _buildQuickStats(textColor, subtitleColor, isDark),
                          const SizedBox(height: 24),

                          // Current Session
                          _buildCurrentSession(
                            textColor,
                            subtitleColor,
                            isDark,
                          ),
                          const SizedBox(height: 24),

                          // Upcoming
                          _buildUpcoming(textColor, subtitleColor, isDark),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
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
    return Container(
      color: isDark
          ? _bgDark.withOpacity(0.8)
          : const Color(0xFFF6F8F6).withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            '${widget.tableName} Details',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Edit',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(bool isDark) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                widget.imageUrl ??
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBkUfJg7xj7qF60evrDC3QD0lxujW_aINJmbwxFvs_GrLwdGUU3j2QntqOKt9VbK9G4w_SJ096wYAj6fBHPkHZhy3D_QRJTs7iZlaqzRQ4M4C_KIUweFeUwUIo0ggtiVvz7QQDwahj_4E_9vh06vZPg3lwwM18j9RMcgcJ9oCZiyfRsRGY-nmvprMvVvkDv2CVhH7HBtA93ygqbiYiLo6CRIA7nNzgJT0AhiDM2hVdnlJGivvnrRH3pDxwqmRkOFzRdkiC4q5LkggQ',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Occupied',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.tableName,
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Main Dining Hall • Window Seat',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(Color textColor, Color subtitleColor, bool isDark) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Capacity',
          '4 People',
          Icons.group,
          textColor,
          subtitleColor,
          isDark,
        ),
        _buildStatCard(
          'Zone',
          'Zone A',
          Icons.grid_view,
          textColor,
          subtitleColor,
          isDark,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color textColor,
    Color subtitleColor,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? _surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFE2E8F0),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: _primary, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSession(
    Color textColor,
    Color subtitleColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Current Session',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Started 45m ago',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? _surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              // Order Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.02)
                      : const Color(0xFFF9FAFB),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: Colors.blue.shade300,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #2034',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'Server: Michael S.',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '\$84.50',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Order Items
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildOrderItem(
                      '2x',
                      'Grilled Salmon',
                      '\$48.00',
                      textColor,
                      subtitleColor,
                    ),
                    const SizedBox(height: 12),
                    _buildOrderItem(
                      '1x',
                      'Caesar Salad',
                      '\$12.50',
                      textColor,
                      subtitleColor,
                    ),
                    const SizedBox(height: 12),
                    _buildOrderItem(
                      '2x',
                      'Iced Lemon Tea',
                      '\$8.00',
                      textColor,
                      subtitleColor,
                    ),
                    const SizedBox(height: 12),
                    _buildOrderItem(
                      '1x',
                      'Tiramisu',
                      '\$16.00',
                      textColor,
                      subtitleColor,
                    ),
                    const SizedBox(height: 16),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              foregroundColor: _bgDark,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Add Items',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                              'Checkout',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: textColor,
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
      ],
    );
  }

  Widget _buildOrderItem(
    String quantity,
    String name,
    String price,
    Color textColor,
    Color subtitleColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              quantity,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        Text(
          price,
          style: GoogleFonts.manrope(fontSize: 12, color: subtitleColor),
        ),
      ],
    );
  }

  Widget _buildUpcoming(Color textColor, Color subtitleColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View Calendar',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? _surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Today',
                      style: GoogleFonts.manrope(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: subtitleColor,
                      ),
                    ),
                    Text(
                      '19:30',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reserv. for Sarah Connor',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '2 Guests • Special Request',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade600),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(bool isDark) {
    final navItems = [
      {'icon': Icons.map, 'label': 'Floor Plan'},
      {'icon': Icons.receipt_long, 'label': 'Orders'},
      {'icon': Icons.table_restaurant, 'label': 'Tables'},
      {'icon': Icons.calendar_today, 'label': 'Bookings'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? _surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(navItems.length, (index) {
          final isActive = _selectedNavTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedNavTab = index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isActive)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      navItems[index]['icon'] as IconData,
                      color: _bgDark,
                      size: 24,
                    ),
                  )
                else
                  Icon(
                    navItems[index]['icon'] as IconData,
                    color: _textSecondary,
                    size: 24,
                  ),
                const SizedBox(height: 4),
                Text(
                  navItems[index]['label'] as String,
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
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
