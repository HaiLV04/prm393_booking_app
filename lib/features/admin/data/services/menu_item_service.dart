import 'package:prm393_booking_app/core/network/api_client.dart';

/// MenuItemService: Handles menu item operations (get items, toggle availability)
/// Backend endpoint base: /api/menu-items
class MenuItemService {
  final ApiClient _apiClient;

  MenuItemService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// GET /api/menu-items
  /// Query params: { categoryId?, isAvailable?, keyword?, page (default: 1), pageSize (default: 10) }
  /// Response: { success, message, data: { items: [...], totalCount, page, pageSize } }
  /// Requires: Authorization header with token
  Future<Map<String, dynamic>> getMenuItems({
    int? categoryId,
    bool? isAvailable,
    String? keyword,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await _apiClient.get(
      '/menu-items',
      query: {
        if (categoryId != null) 'categoryId': categoryId,
        if (isAvailable != null) 'isAvailable': isAvailable,
        if (keyword != null) 'keyword': keyword,
        'page': page,
        'pageSize': pageSize,
      },
      requiresAuth: true,
    );
  }

  /// GET /api/menu-items/{id}
  /// Response: { success, message, data: { id, categoryId, categoryName, name, description, price, imageUrl, isAvailable } }
  /// Requires: Authorization header with token
  Future<Map<String, dynamic>> getMenuItemById(int itemId) async {
    return await _apiClient.get(
      '/menu-items/$itemId',
      requiresAuth: true,
    );
  }

  /// POST /api/menu-items
  /// Request: { categoryId (required), name (required), description?, price (required), imageUrl?, isAvailable (default: true) }
  /// Response: { success, message, data: { id, categoryId, name, price, isAvailable, ... } }
  /// Requires: Authorization header with token (admin only)
  Future<Map<String, dynamic>> createMenuItem({
    required int categoryId,
    required String name,
    required double price,
    String? description,
    String? imageUrl,
    bool isAvailable = true,
  }) async {
    return await _apiClient.post(
      '/menu-items',
      body: {
        'categoryId': categoryId,
        'name': name,
        'price': price,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'isAvailable': isAvailable,
      },
      requiresAuth: true,
    );
  }

  /// PUT /api/menu-items/{id}
  /// Request: { categoryId (required), name (required), description?, price (required), imageUrl?, isAvailable }
  /// Response: { success, message }
  /// Requires: Authorization header with token (admin only)
  Future<Map<String, dynamic>> updateMenuItem({
    required int itemId,
    required int categoryId,
    required String name,
    required double price,
    String? description,
    String? imageUrl,
    bool isAvailable = true,
  }) async {
    return await _apiClient.post( // Dart http doesn't provide PUT, using POST (backend should handle)
      '/menu-items/$itemId',
      body: {
        'categoryId': categoryId,
        'name': name,
        'price': price,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'isAvailable': isAvailable,
      },
      requiresAuth: true,
    );
  }

  /// PATCH /api/menu-items/{id}/availability
  /// Request: { isAvailable (required: boolean) }
  /// Response: { success, message }
  /// Requires: Authorization header with token (admin only)
  Future<Map<String, dynamic>> toggleAvailability({
    required int itemId,
    required bool isAvailable,
  }) async {
    return await _apiClient.post(
      '/menu-items/$itemId/availability',
      body: {'isAvailable': isAvailable},
      requiresAuth: true,
    );
  }

  /// DELETE /api/menu-items/{id}
  /// Response: { success, message }
  /// Requires: Authorization header with token (admin only)
  /// Note: This requires ApiClient to support DELETE - check if implemented
  Future<Map<String, dynamic>> deleteMenuItem(int itemId) async {
    // Placeholder - implement DELETE in ApiClient if needed
    throw UnimplementedError('DELETE not yet implemented in ApiClient');
  }
}
