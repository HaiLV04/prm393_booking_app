import 'package:prm393_booking_app/core/network/api_client.dart';

/// AdminStatisticsService: Handles admin dashboard statistics
/// Backend endpoint base: /api/admin/statistics and /api/admin/dashboard
class AdminStatisticsService {
  final ApiClient _apiClient;

  AdminStatisticsService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// GET /api/admin/dashboard/summary
  /// Response: { success, message, data: { totalTables, occupiedTables, todayOrders, todayRevenue } }
  /// Requires: Authorization header with token (admin only)
  Future<Map<String, dynamic>> getDashboardSummary() async {
    return await _apiClient.get(
      '/api/admin/dashboard/summary',
      requiresAuth: true,
    );
  }

  /// GET /api/admin/statistics/revenue
  /// Query params: { period: 'today' | 'week' | 'month' (default: 'today') }
  /// Response: { success, message, data: { period, revenue, totalInvoices } }
  /// Requires: Authorization header with token (admin only)
  Future<Map<String, dynamic>> getRevenueStatistics({
    String period = 'today',
  }) async {
    const validPeriods = {'today', 'week', 'month'};
    if (!validPeriods.contains(period)) {
      throw ApiException(
        message: 'Invalid period. Must be one of: today, week, month',
        statusCode: 400,
        body: {},
      );
    }

    return await _apiClient.get(
      '/api/admin/statistics/revenue',
      query: {'period': period},
      requiresAuth: true,
    );
  }

  /// GET /api/admin/statistics/top-items
  /// Query params: { from?, to?, limit (default: 10) }
  /// Response: { success, message, data: [ { menuItemId, menuItemName, totalQuantity, totalRevenue }, ... ] }
  /// Requires: Authorization header with token (admin only)
  Future<Map<String, dynamic>> getTopItems({
    DateTime? from,
    DateTime? to,
    int limit = 10,
  }) async {
    return await _apiClient.get(
      '/api/admin/statistics/top-items',
      query: {
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
        'limit': limit,
      },
      requiresAuth: true,
    );
  }

  /// GET /api/admin/statistics/overview
  /// Query params: { period: 'today' | 'week' | 'month', topLimit: 5 }
  /// Response: { success, message, data: { revenue: {...}, topItems: [...] } }
  Future<Map<String, dynamic>> getStatisticsOverview({
    String period = 'today',
    int topLimit = 5,
  }) async {
    const validPeriods = {'today', 'week', 'month'};
    if (!validPeriods.contains(period)) {
      throw ApiException(
        message: 'Invalid period. Must be one of: today, week, month',
        statusCode: 400,
        body: {},
      );
    }

    return await _apiClient.get(
      '/api/admin/statistics/overview',
      query: {
        'period': period,
        'topLimit': topLimit,
      },
      requiresAuth: true,
    );
  }

  /// GET /api/areas (for occupancy data)
  /// Response: { success, message, data: [ { id, name, description, isActive }, ... ] }
  /// Requires: Authorization header with token
  /// Note: This endpoint provides area list; occupancy rates would need to be calculated
  ///       from table status data or a dedicated endpoint
  Future<Map<String, dynamic>> getAreas() async {
    return await _apiClient.get(
      '/api/areas',
      requiresAuth: true,
    );
  }

  /// GET /api/tables (with query params for detailed filtering)
  /// Query params: { areaId?, status?, keyword?, page, pageSize }
  /// Response: { success, message, data: { items: [...], totalCount, page, pageSize } }
  /// Requires: Authorization header with token
  /// Note: Can be used to calculate occupancy rates and peak hours
  Future<Map<String, dynamic>> getTables({
    int? areaId,
    String? status,
    int page = 1,
    int pageSize = 100, // Get all for statistics
  }) async {
    return await _apiClient.get(
      '/api/tables',
      query: {
        if (areaId != null) 'areaId': areaId,
        if (status != null && status.isNotEmpty) 'status': status,
        'page': page,
        'pageSize': pageSize,
      },
      requiresAuth: true,
    );
  }

  /// GET /api/orders (with date filtering for peak hours analysis)
  /// Query params: { from?, to?, page, pageSize }
  /// Note: This endpoint doesn't exist yet in backend, but would be useful
  /// Response: { success, message, data: { items: [...], totalCount } }
  Future<Map<String, dynamic>> getOrdersByDateRange({
    DateTime? from,
    DateTime? to,
    int page = 1,
    int pageSize = 100,
  }) async {
    // This is a placeholder - check if backend supports this query
    return await _apiClient.get(
      '/api/orders',
      query: {
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
        'page': page,
        'pageSize': pageSize,
      },
      requiresAuth: true,
    );
  }
}
