import 'package:prm393_booking_app/core/network/api_client.dart';

/// CategoryService: Handles category operations (get categories, CRUD)
/// Backend endpoint base: /api/categories
class CategoryService {
  final ApiClient _apiClient;

  CategoryService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// GET /api/categories
  /// Response: { success, message, data: [ { id, name, imageUrl, displayOrder, isActive }, ... ] }
  /// Requires: Authorization header with token
  Future<Map<String, dynamic>> getAllCategories() async {
    return await _apiClient.get(
      '/categories',
      requiresAuth: true,
    );
  }

  /// GET /api/categories/{id}
  /// Response: { success, message, data: { id, name, imageUrl, displayOrder, isActive } }
  /// Requires: Authorization header with token
  Future<Map<String, dynamic>> getCategoryById(int categoryId) async {
    return await _apiClient.get(
      '/categories/$categoryId',
      requiresAuth: true,
    );
  }

  /// POST /api/categories
  /// Request: { name (required), imageUrl?, displayOrder (default: 0) }
  /// Response: { success, message, data: { id, name, imageUrl, displayOrder, isActive } }
  /// Requires: Authorization header with token (admin only)
  Future<Map<String, dynamic>> createCategory({
    required String name,
    String? imageUrl,
    int displayOrder = 0,
  }) async {
    return await _apiClient.post(
      '/categories',
      body: {
        'name': name,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'displayOrder': displayOrder,
      },
      requiresAuth: true,
    );
  }

  /// PUT /api/categories/{id}
  /// Request: { name (required), imageUrl?, displayOrder }
  /// Response: { success, message }
  /// Requires: Authorization header with token (admin only)
  Future<Map<String, dynamic>> updateCategory({
    required int categoryId,
    required String name,
    String? imageUrl,
    int? displayOrder,
  }) async {
    return await _apiClient.post(
      '/categories/$categoryId',
      body: {
        'name': name,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (displayOrder != null) 'displayOrder': displayOrder,
      },
      requiresAuth: true,
    );
  }

  /// PATCH /api/categories/{id}/active
  /// Request: { isActive (required: boolean) }
  /// Response: { success, message }
  /// Requires: Authorization header with token (admin only)
  Future<Map<String, dynamic>> toggleCategoryActive({
    required int categoryId,
    required bool isActive,
  }) async {
    return await _apiClient.post(
      '/categories/$categoryId/active',
      body: {'isActive': isActive},
      requiresAuth: true,
    );
  }
}
