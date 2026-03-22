import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/services/admin_statistics_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  static const Color _darkBackground = Color(0xFF151D18);

  late final AdminStatisticsService _statisticsService;

  String _selectedPeriod = 'today';
  bool _isLoading = true;
  String? _errorMessage;

  Map<String, dynamic> _currentStats = {};
  List<Map<String, dynamic>> _topItems = [];

  @override
  void initState() {
    super.initState();
    _statisticsService = AdminStatisticsService(apiClient: ApiClient());
    _loadStatistics();
  }

  Future<void> _loadStatistics({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await _statisticsService.getStatisticsOverview(
        period: _selectedPeriod,
        topLimit: 5,
      );

      final data = _asMap(response['data']);
      final revenueRaw = _asMap(data['revenue']);
      final topItemsRaw = _asList(data['topItems']);

      final stats = _normalizeRevenueData(revenueRaw);
      final items = topItemsRaw
          .whereType<Map>()
          .map((item) {
            final map = item.cast<String, dynamic>();
            final imageUrl = _normalizeNullableString(map['imageUrl']);
            return <String, dynamic>{
              'name': _normalizeString(
                map['menuItemName'] ?? map['name'],
                fallback: 'Món ăn',
              ),
              'category': _normalizeString(
                map['categoryName'] ?? map['category'],
                fallback: 'Chưa phân loại',
              ),
              'sold': (map['totalQuantity'] as num?)?.toInt() ??
                  (map['sold'] as num?)?.toInt() ??
                  0,
              'imageUrl': imageUrl,
            };
          })
          .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _currentStats = stats;
        _topItems = items;
        _isLoading = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể tải dữ liệu thống kê. Vui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? _darkBackground : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : AppColors.textMain;
    final subtitleColor = isDark ? const Color(0xFF9DB9A6) : AppColors.textSub;
    final borderColor = AppColors.primary.withOpacity(isDark ? 0.2 : 0.12);

    final stats = _currentStats.length == 0 ? _defaultStats() : _currentStats;
    final chartValues = List<double>.from(
      _asList(stats['chart'])
          .map((value) => (value as num).toDouble()),
    );
    final labels = List<String>.from(_asList(stats['labels']).map((item) => item.toString()));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(textColor, borderColor, backgroundColor),
            _buildPeriodSelector(textColor, subtitleColor, isDark),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : _errorMessage != null
                      ? _buildErrorState(textColor, subtitleColor)
                      : SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRevenueSummary(
                                stats,
                                textColor,
                                subtitleColor,
                                isDark,
                              ),
                              _buildChartSection(
                                values: chartValues,
                                labels: labels,
                                textColor: textColor,
                                subtitleColor: subtitleColor,
                                borderColor: borderColor,
                                isDark: isDark,
                              ),
                              _buildTopItemsSection(textColor, subtitleColor),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, Color borderColor, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.95),
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back, color: textColor),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Thống kê',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(Color textColor, Color subtitleColor, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildPeriodButton('today', 'Hôm nay', textColor, subtitleColor, isDark),
          const SizedBox(width: 8),
          _buildPeriodButton('week', 'Tuần', textColor, subtitleColor, isDark),
          const SizedBox(width: 8),
          _buildPeriodButton('month', 'Tháng', textColor, subtitleColor, isDark),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    String period,
    String label,
    Color textColor,
    Color subtitleColor,
    bool isDark,
  ) {
    final isSelected = _selectedPeriod == period;
    return InkWell(
      onTap: () {
        if (_selectedPeriod == period) {
          return;
        }

        setState(() {
          _selectedPeriod = period;
        });
        _loadStatistics(showLoading: true);
      },
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withOpacity(isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : subtitleColor,
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueSummary(
    Map<String, dynamic> stats,
    Color textColor,
    Color subtitleColor,
    bool isDark,
  ) {
    final growth = (stats['growth'] as num?)?.toDouble() ?? 0;
    final isPositiveGrowth = growth >= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withOpacity(isDark ? 0.2 : 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stats['title'] as String,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '${_formatCurrency(stats['revenue'] as num? ?? 0)}đ',
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isPositiveGrowth ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: isPositiveGrowth
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${isPositiveGrowth ? '+' : ''}${_formatPercent(growth)}%',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isPositiveGrowth
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              stats['subtitle'] as String,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection({
    required List<double> values,
    required List<String> labels,
    required Color textColor,
    required Color subtitleColor,
    required Color borderColor,
    required bool isDark,
  }) {
    final maxValue = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    final safeMaxValue = maxValue <= 0 ? 1.0 : maxValue;
    final highlightedIndex = values.length - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng quan doanh thu',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 256,
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(isDark ? 0.2 : 0.16),
                  AppColors.primary.withOpacity(isDark ? 0.08 : 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(values.length, (index) {
                      final value = values[index];
                      final ratio = value / safeMaxValue;
                      final highlighted = index == highlightedIndex;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 18,
                                child: highlighted
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.75),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          _formatCompactMillion(value),
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                height: 150 * ratio,
                                decoration: BoxDecoration(
                                  color: highlighted
                                      ? AppColors.primary
                                      : AppColors.primary.withOpacity(
                                          isDark ? 0.58 : 0.4,
                                        ),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(labels.length, (index) {
                    final highlighted = index == highlightedIndex;
                    return Expanded(
                      child: Text(
                        labels[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
                          color: highlighted ? AppColors.primary : subtitleColor,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopItemsSection(Color textColor, Color subtitleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Text(
            'Top 5 bán chạy',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _topItems.length == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  child: Text(
                    'Chưa có dữ liệu món bán chạy trong khoảng thời gian này.',
                    style: GoogleFonts.inter(fontSize: 13, color: subtitleColor),
                  ),
                )
              : Column(
                  children: List.generate(_topItems.length, (index) {
                    final item = _topItems[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['category'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${item['sold']}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'Đã bán',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
        ),
      ],
    );
  }

  Widget _buildErrorState(Color textColor, Color subtitleColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: textColor, size: 28),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Có lỗi xảy ra.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: subtitleColor),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadStatistics,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _defaultStats() {
    return {
      'title': _defaultTitle(_selectedPeriod),
      'revenue': 0.0,
      'growth': 0.0,
      'subtitle': _defaultSubtitle(_selectedPeriod),
      'chart': List<double>.filled(_defaultLabels(_selectedPeriod).length, 0),
      'labels': _defaultLabels(_selectedPeriod),
    };
  }

  Map<String, dynamic> _normalizeRevenueData(Map<String, dynamic> raw) {
    final chartValuesRaw = _asList(raw['chartValues']);
    final fallbackChartValuesRaw = _asList(raw['chart']);
    final labelsRaw = _asList(raw['chartLabels']);
    final fallbackLabelsRaw = _asList(raw['labels']);

    final sourceChartValues = chartValuesRaw.length > 0
      ? chartValuesRaw
      : fallbackChartValuesRaw;
    final sourceLabels = labelsRaw.length > 0 ? labelsRaw : fallbackLabelsRaw;

    final chartValues =
      sourceChartValues.map((value) => (value as num?)?.toDouble() ?? 0).toList();
    final labels = sourceLabels.map((label) => label.toString()).toList();

    if (chartValues.length == 0 || labels.length == 0 || chartValues.length != labels.length) {
      return _defaultStats()
        ..['revenue'] = (raw['revenue'] as num?)?.toDouble() ?? 0
        ..['growth'] = (raw['revenueChangePercent'] as num?)?.toDouble() ?? 0;
    }

    return {
      'title': (raw['title'] as String?) ?? _defaultTitle(_selectedPeriod),
      'revenue': (raw['revenue'] as num?)?.toDouble() ?? 0,
      'growth': (raw['revenueChangePercent'] as num?)?.toDouble() ?? 0,
      'subtitle': (raw['subtitle'] as String?) ?? _defaultSubtitle(_selectedPeriod),
      'chart': chartValues,
      'labels': labels,
    };
  }

  List<String> _defaultLabels(String period) {
    switch (period) {
      case 'week':
        return ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
      case 'month':
        return ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4'];
      default:
        return ['08:00', '10:00', '12:00', '14:00', '16:00', '18:00', '20:00'];
    }
  }

  String _defaultTitle(String period) {
    switch (period) {
      case 'week':
        return 'Doanh thu tuần này';
      case 'month':
        return 'Doanh thu tháng này';
      default:
        return 'Doanh thu hôm nay';
    }
  }

  String _defaultSubtitle(String period) {
    switch (period) {
      case 'week':
        return 'So với tuần trước';
      case 'month':
        return 'So với tháng trước';
      default:
        return 'So với cùng kỳ hôm qua';
    }
  }

  String _formatCurrency(num value) {
    final text = value.round().toString();
    final buffer = StringBuffer();
    var count = 0;
    for (var index = text.length - 1; index >= 0; index--) {
      buffer.write(text[index]);
      count++;
      if (count % 3 == 0 && index > 0) {
        buffer.write(',');
      }
    }
    return buffer.toString().split('').reversed.join();
  }

  String _formatPercent(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  String _formatCompactMillion(num value) {
    final million = value / 1000000;
    if (million >= 10) {
      return '${million.toStringAsFixed(1)}M';
    }
    return '${million.toStringAsFixed(2)}M';
  }

  String _normalizeString(dynamic value, {required String fallback}) {
    final normalized = _normalizeNullableString(value);
    return normalized ?? fallback;
  }

  String? _normalizeNullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    if (text.length == 0 || text == 'undefined' || text == 'null') {
      return null;
    }

    return text;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), val),
      );
    }

    return <String, dynamic>{};
  }

  List<dynamic> _asList(dynamic value) {
    if (value is List) {
      return List<dynamic>.from(value);
    }

    if (value is Iterable) {
      return value.toList();
    }

    return const <dynamic>[];
  }
}
