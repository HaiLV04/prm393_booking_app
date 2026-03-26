class DashboardData {
  const DashboardData({
    required this.totalTables,
    required this.occupiedTables,
    required this.todayOrders,
    required this.revenue,
  });

  final int totalTables;
  final int occupiedTables;
  final int todayOrders;
  final double revenue;

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final totalTables = json['totalTables'] ?? json['TotalTables'] ?? 0;
    final occupiedTables =
        json['occupiedTables'] ?? json['OccupiedTables'] ?? 0;
    final todayOrders = json['todayOrders'] ?? json['TodayOrders'] ?? 0;
    final revenue =
        json['todayRevenue'] ?? json['TodayRevenue'] ?? json['revenue'] ?? 0.0;

    return DashboardData(
      totalTables: (totalTables as num).toInt(),
      occupiedTables: (occupiedTables as num).toInt(),
      todayOrders: (todayOrders as num).toInt(),
      revenue: (revenue as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTables': totalTables,
      'occupiedTables': occupiedTables,
      'todayOrders': todayOrders,
      'revenue': revenue,
    };
  }
}
