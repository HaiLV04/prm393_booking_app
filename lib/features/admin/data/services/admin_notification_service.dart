import 'package:prm393_booking_app/core/models/admin_notification.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';

class AdminNotificationService {
  AdminNotificationService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<AdminNotification>> getMyNotifications() async {
    final response = await _apiClient.get(
      '/api/notifications',
      requiresAuth: true,
    );

    final payload = response['data'] ?? response['Data'] ?? const [];
    final items = payload is List ? payload : const [];

    return items
        .whereType<Map>()
        .map((item) => AdminNotification.fromJson(
        Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> markAsRead(int notificationId) async {
    await _apiClient.patch(
      '/api/notifications/$notificationId/read',
      requiresAuth: true,
    );
  }
}
