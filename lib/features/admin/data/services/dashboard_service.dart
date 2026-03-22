import 'package:prm393_booking_app/core/models/dashboard.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';

class DashboardService {
  DashboardService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<DashboardData> getDashboardData() async {
    try {
      final response = await _apiClient.get('/api/admin/dashboard/summary');
      final data = response['data'] as Map<String, dynamic>? ?? response;
      return DashboardData.fromJson(data);
    } catch (e) {
      // Return default data if API fails
      return const DashboardData(
        totalTables: 0,
        occupiedTables: 0,
        todayOrders: 0,
        revenue: 0.0,
      );
    }
  }
}
