import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/core/models/admin_menu_item.dart';

/// MenuItemService: Handles menu item operations (get items, toggle availability)
/// Backend endpoint base: /api/menu-items
class MenuItemService {
  final ApiClient _apiClient;

  MenuItemService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// GET /api/menu-items
  /// Query params: { categoryId?, isAvailable?, keyword?, page (default: 1), pageSize (default: 10) }
  /// Response: { success, message, data: { items: [...], totalCount, page, pageSize } }
  /// Requires: Authorization header with token
  Future<List<AdminMenuItem>> getMenuItems({
    int? categoryId,
    bool? isAvailable,
    String? keyword,
    int page = 1,
    int pageSize = 100,
  }) async {
    final response = await _apiClient.get(
      '/api/menu-items',
      query: _buildQuery(
        categoryId: categoryId,
        isAvailable: isAvailable,
        keyword: keyword,
        page: page,
        pageSize: pageSize,
      ),
      requiresAuth: true,
    );

    final payload = response['data'] ?? response['Data'] ?? <String, dynamic>{};
    final itemsRaw =
        (payload['items'] ?? payload['Items']) as List<dynamic>? ??
        const <dynamic>[];
    return itemsRaw
        .whereType<Map<String, dynamic>>()
        .map(AdminMenuItem.fromJson)
        .toList();
  }

  /// GET /api/menu-items/{id}
  /// Response: { success, message, data: { id, categoryId, categoryName, name, description, price, imageUrl, isAvailable } }
  /// Requires: Authorization header with token
  Future<AdminMenuItem> getMenuItemById(int itemId) async {
    final response = await _apiClient.get(
      '/api/menu-items/$itemId',
      requiresAuth: true,
    );
    final payload = response['data'] ?? response['Data'] ?? <String, dynamic>{};
    return AdminMenuItem.fromJson(payload as Map<String, dynamic>);
  }

  /// POST /api/menu-items
  /// Request: { categoryId (required), name (required), description?, price (required), imageUrl?, isAvailable (default: true) }
  /// Response: { success, message, data: { id, categoryId, name, price, isAvailable, ... } }
  /// Requires: Authorization header with token (admin only)
  Future<AdminMenuItem> createMenuItem({
    required int categoryId,
    required String name,
    required double price,
    String? description,
    String? imageUrl,
    bool isAvailable = true,
  }) async {
    final response = await _apiClient.post(
      '/api/menu-items',
      body: _buildRequestBody(
        categoryId: categoryId,
        name: name,
        price: price,
        description: description,
        imageUrl: imageUrl,
        isAvailable: isAvailable,
      ),
      requiresAuth: true,
    );

    final payload = response['data'] ?? response['Data'] ?? <String, dynamic>{};
    return AdminMenuItem.fromJson(payload as Map<String, dynamic>);
  }

  /// PUT /api/menu-items/{id}
  /// Request: { categoryId (required), name (required), description?, price (required), imageUrl?, isAvailable }
  /// Response: { success, message }
  /// Requires: Authorization header with token (admin only)
  Future<void> updateMenuItem({
    required int itemId,
    required int categoryId,
    required String name,
    required double price,
    String? description,
    String? imageUrl,
    bool isAvailable = true,
  }) async {
    await _apiClient.put(
      '/api/menu-items/$itemId',
      body: _buildRequestBody(
        categoryId: categoryId,
        name: name,
        price: price,
        description: description,
        imageUrl: imageUrl,
        isAvailable: isAvailable,
      ),
      requiresAuth: true,
    );
  }

  /// PATCH /api/menu-items/{id}/availability
  /// Request: { isAvailable (required: boolean) }
  /// Response: { success, message }
  /// Requires: Authorization header with token (admin only)
  Future<void> toggleAvailability({
    required int itemId,
    required bool isAvailable,
  }) async {
    await _apiClient.patch(
      '/api/menu-items/$itemId/availability',
      body: {'isAvailable': isAvailable},
      requiresAuth: true,
    );
  }

  Map<String, dynamic> _buildRequestBody({
    required int categoryId,
    required String name,
    required double price,
    String? description,
    String? imageUrl,
    required bool isAvailable,
  }) {
    return <String, dynamic>{
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'description': description?.trim().isEmpty ?? true
          ? null
          : description?.trim(),
      'imageUrl': imageUrl?.trim().isEmpty ?? true ? null : imageUrl?.trim(),
      'isAvailable': isAvailable,
    }..removeWhere((key, value) => value == null);
  }

  Map<String, dynamic> _buildQuery({
    int? categoryId,
    bool? isAvailable,
    String? keyword,
    required int page,
    required int pageSize,
  }) {
    return <String, dynamic>{
      'categoryId': categoryId,
      'isAvailable': isAvailable,
      'keyword': keyword?.trim().isEmpty ?? true ? null : keyword?.trim(),
      'page': page,
      'pageSize': pageSize,
    }..removeWhere((key, value) => value == null);
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
