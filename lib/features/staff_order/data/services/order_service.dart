import 'package:prm393_booking_app/core/network/api_client.dart';

/// OrderService: Handles order operations (get orders, add items, update status)
/// Backend endpoint base: /api/orders
class OrderService {
  final ApiClient _apiClient;

  OrderService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// GET /api/orders/{id}
  /// Response: { success, message, data: { id, reservationId, totalAmount, status, note, createdAt, updatedAt } }
  /// Requires: Authorization header with token
  Future<Map<String, dynamic>> getOrderById(int orderId) async {
    return await _apiClient.get(
      '/orders/$orderId',
      requiresAuth: true,
    );
  }

  /// GET /api/orders/by-reservation/{reservationId}
  /// Response: { success, message, data: { id, reservationId, totalAmount, status, note, createdAt, updatedAt } }
  /// Requires: Authorization header with token
  Future<Map<String, dynamic>> getOrderByReservationId(int reservationId) async {
    return await _apiClient.get(
      '/orders/by-reservation/$reservationId',
      requiresAuth: true,
    );
  }

  /// GET /api/orders/{orderId}/items
  /// Response: { success, message, data: [ { id, orderId, menuItemId, menuItemName, quantity, unitPrice, note, itemStatus }, ... ] }
  /// Requires: Authorization header with token
  Future<Map<String, dynamic>> getOrderItems(int orderId) async {
    return await _apiClient.get(
      '/orders/$orderId/items',
      requiresAuth: true,
    );
  }

  /// POST /api/orders/{orderId}/items
  /// Request: { menuItemId (required), quantity (optional, default: 1), note (optional) }
  /// Response: { success, message, data: { id, orderId, menuItemId, quantity, unitPrice, note, itemStatus } }
  /// Requires: Authorization header with token (staff or admin)
  Future<Map<String, dynamic>> addOrderItem({
    required int orderId,
    required int menuItemId,
    int quantity = 1,
    String? note,
  }) async {
    return await _apiClient.post(
      '/orders/$orderId/items',
      body: {
        'menuItemId': menuItemId,
        'quantity': quantity,
        if (note != null) 'note': note,
      },
      requiresAuth: true,
    );
  }

  /// PATCH /api/orders/{orderDetailId}/status
  /// Request: { status (required: 'pending' | 'preparing' | 'served' | 'cancelled') }
  /// Response: { success, message }
  /// Requires: Authorization header with token (staff or admin)
  Future<Map<String, dynamic>> updateItemStatus({
    required int orderDetailId,
    required String status,
  }) async {
    const validStatuses = {'pending', 'preparing', 'served', 'cancelled'};
    if (!validStatuses.contains(status)) {
      throw ApiException(
        message:
            'Invalid status. Must be one of: pending, preparing, served, cancelled',
        statusCode: 400,
        body: {},
      );
    }

    return await _apiClient.post( // Note: Many APIs use POST with /status endpoint even for updates
      '/orders/$orderDetailId/status',
      body: {'status': status},
      requiresAuth: true,
    );
  }
}
