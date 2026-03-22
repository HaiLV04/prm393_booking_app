import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// StatisticsScreen: Admin views business metrics and reports
/// Business Logic:
/// 1. Display revenue metrics (daily, weekly, monthly)
/// 2. Show best-selling menu items
/// 3. Display dining area occupancy rates
/// 4. Show peak hours analysis
/// 5. Generate reports for business decisions
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'today'; // today, week, month
  bool _isLoading = false;

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _surfaceDark = Color(0xFF1C2E21);
  static const Color _textSecondary = Color(0xFF9DB9A6);

  // Mock statistics data
  final Map<String, dynamic> _stats = {
    'today': {
      'revenue': 4500000,
      'orders': 18,
      'tables': 12,
      'avgOrderValue': 250000,
    },
    'week': {
      'revenue': 28500000,
      'orders': 124,
      'tables': 78,
      'avgOrderValue': 229838,
    },
    'month': {
      'revenue': 112000000,
      'orders': 512,
      'tables': 320,
      'avgOrderValue': 218750,
    },
  };

  final List<Map<String, dynamic>> _topItems = [
    {'name': 'Cơm mực', 'sold': 156, 'revenue': 23400000},
    {'name': 'Canh cua', 'sold': 142, 'revenue': 17050000},
    {'name': 'Nước ép cam', 'sold': 189, 'revenue': 8505000},
    {'name': 'Kem tiramisu', 'sold': 98, 'revenue': 5880000},
    {'name': 'Salad rau xanh', 'sold': 87, 'revenue': 7395000},
  ];

  final List<Map<String, dynamic>> _areaOccupancy = [
    {'name': 'Main Indoor Hall', 'occupied': 32, 'total': 40, 'occupancy': 0.8},
    {'name': 'Terrace Garden', 'occupied': 12, 'total': 15, 'occupancy': 0.8},
    {'name': 'VIP Lounge', 'occupied': 6, 'total': 8, 'occupancy': 0.75},
  ];

  final List<Map<String, dynamic>> _peakHours = [
    {'hour': '11', 'orders': 2},
    {'hour': '12', 'orders': 8},
    {'hour': '13', 'orders': 6},
    {'hour': '18', 'orders': 7},
    {'hour': '19', 'orders': 9},
    {'hour': '20', 'orders': 5},
    {'hour': '21', 'orders': 3},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _bgDark : const Color(0xFFF6F8F6);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? _textSecondary : const Color(0xFF64748B);
    final surfaceColor = isDark ? _surfaceDark : Colors.white;

    final currentStats = _stats[_selectedPeriod] ?? _stats['today']!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(textColor, isDark),

            // Period Selector
            _buildPeriodSelector(textColor),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPI Cards
                    _buildKPICards(currentStats, textColor, surfaceColor),
                    const SizedBox(height: 24),

                    // Top Selling Items
                    _buildTopItemsSection(textColor, subtitleColor, surfaceColor),
                    const SizedBox(height: 24),

                    // Area Occupancy
                    _buildAreaOccupancySection(textColor, subtitleColor, surfaceColor),
                    const SizedBox(height: 24),

                    // Peak Hours
                    _buildPeakHoursSection(textColor, subtitleColor, surfaceColor),
                    const SizedBox(height: 32),

                    // Export Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Export report to PDF/Excel
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Xuất báo cáo sẽ được triển khai'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Xuất báo cáo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? _surfaceDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8E4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: textColor),
          ),
          const SizedBox(width: 16),
          Text(
            'Thống kê & Báo cáo',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const Spacer(),
          Icon(Icons.show_chart, color: _primary),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(Color textColor) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildPeriodButton('today', 'Hôm nay', textColor),
          const SizedBox(width: 8),
          _buildPeriodButton('week', 'Tuần này', textColor),
          const SizedBox(width: 8),
          _buildPeriodButton('month', 'Tháng này', textColor),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period, String label, Color textColor) {
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _primary : Colors.transparent,
          border: isSelected ? null : Border.all(color: _primary, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildKPICards(
    Map<String, dynamic> stats,
    Color textColor,
    Color surfaceColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chỉ số chính',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildKPICard(
                'Doanh thu',
                '${(stats['revenue'] / 1000000).toStringAsFixed(1)}M',
                Icons.trending_up,
                Colors.green,
                textColor,
                surfaceColor,
              ),
              const SizedBox(width: 12),
              _buildKPICard(
                'Đơn hàng',
                stats['orders'].toString(),
                Icons.shopping_cart,
                Colors.blue,
                textColor,
                surfaceColor,
              ),
              const SizedBox(width: 12),
              _buildKPICard(
                'Bàn phục vụ',
                stats['tables'].toString(),
                Icons.event_available,
                Colors.orange,
                textColor,
                surfaceColor,
              ),
              const SizedBox(width: 12),
              _buildKPICard(
                'Trung bình/Đơn',
                '${(stats['avgOrderValue'] / 1000).toStringAsFixed(0)}k',
                Icons.money,
                _primary,
                textColor,
                surfaceColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(
    String label,
    String value,
    IconData icon,
    Color color,
    Color textColor,
    Color surfaceColor,
  ) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopItemsSection(Color textColor, Color subtitleColor, Color surfaceColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Món bán chạy nhất',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(_topItems.length, (index) {
              final item = _topItems[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: _primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                '${item['sold']} bán',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${(item['revenue'] / 1000000).toStringAsFixed(1)}M',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < _topItems.length - 1)
                    Divider(height: 1, indent: 56, endIndent: 0),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAreaOccupancySection(
    Color textColor,
    Color subtitleColor,
    Color surfaceColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tỷ lệ sử dụng bàn theo khu vực',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(_areaOccupancy.length, (index) {
              final area = _areaOccupancy[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              area['name'],
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            Text(
                              '${(area['occupancy'] * 100).toStringAsFixed(0)}%',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: area['occupancy'],
                            minHeight: 6,
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(_primary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${area['occupied']}/${area['total']} bàn',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < _areaOccupancy.length - 1)
                    Divider(height: 1, indent: 12, endIndent: 12),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPeakHoursSection(
    Color textColor,
    Color subtitleColor,
    Color surfaceColor,
  ) {
    final maxOrders = _peakHours.fold<int>(
      0,
      (max, item) => item['orders'] > max ? item['orders'] : max,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giờ cao điểm',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _peakHours.map((item) {
              return Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 24,
                          height: (item['orders'] / maxOrders) * 60,
                          decoration: BoxDecoration(
                            color: _primary.withOpacity(0.8),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item['hour']}h',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
