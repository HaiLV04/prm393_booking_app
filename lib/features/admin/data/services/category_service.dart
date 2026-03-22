import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/core/models/admin_category.dart';

/// CategoryService: Handles category operations (get categories, CRUD)
/// Backend endpoint base: /api/categories
class CategoryService {
  final ApiClient _apiClient;

  CategoryService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// GET /api/categories
  /// Response: { success, message, data: [ { id, name, imageUrl, displayOrder, isActive }, ... ] }
  /// Requires: Authorization header with token
  Future<List<AdminCategory>> getAllCategories() async {
    final response = await _apiClient.get(
      '/api/categories',
      requiresAuth: true,
    );
    final payload = response['data'] ?? response['Data'];
    final items = (payload as List<dynamic>? ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(AdminCategory.fromJson)
        .toList();
    return items;
  }

  /// GET /api/categories/{id}
  /// Response: { success, message, data: { id, name, imageUrl, displayOrder, isActive } }
  /// Requires: Authorization header with token
  Future<AdminCategory> getCategoryById(int categoryId) async {
    final response = await _apiClient.get(
      '/api/categories/$categoryId',
      requiresAuth: true,
    );
    final payload = response['data'] ?? response['Data'] ?? <String, dynamic>{};
    return AdminCategory.fromJson(payload as Map<String, dynamic>);
  }

  /// POST /api/categories
  /// Request: { name (required), imageUrl?, displayOrder (default: 0) }
  /// Response: { success, message, data: { id, name, imageUrl, displayOrder, isActive } }
  /// Requires: Authorization header with token (admin only)
  Future<AdminCategory> createCategory({
    required String name,
    String? imageUrl,
    int displayOrder = 0,
  }) async {
    final response = await _apiClient.post(
      '/api/categories',
      body: _buildCategoryBody(
        name: name,
        imageUrl: imageUrl,
        displayOrder: displayOrder,
      ),
      requiresAuth: true,
    );
    final payload = response['data'] ?? response['Data'] ?? <String, dynamic>{};
    return AdminCategory.fromJson(payload as Map<String, dynamic>);
  }

  /// PUT /api/categories/{id}
  /// Request: { name (required), imageUrl?, displayOrder }
  /// Response: { success, message }
  /// Requires: Authorization header with token (admin only)
  Future<void> updateCategory({
    required int categoryId,
    required String name,
    String? imageUrl,
    int? displayOrder,
  }) async {
    await _apiClient.put(
      '/api/categories/$categoryId',
      body: _buildCategoryBody(
        name: name,
        imageUrl: imageUrl,
        displayOrder: displayOrder ?? 0,
      ),
      requiresAuth: true,
    );
  }

  /// PATCH /api/categories/{id}/active
  /// Request: { isActive (required: boolean) }
  /// Response: { success, message }
  /// Requires: Authorization header with token (admin only)
  Future<void> toggleCategoryActive({
    required int categoryId,
    required bool isActive,
  }) async {
    await _apiClient.patch(
      '/api/categories/$categoryId/active',
      body: {'isActive': isActive},
      requiresAuth: true,
    );
  }

  Map<String, dynamic> _buildCategoryBody({
    required String name,
    String? imageUrl,
    required int displayOrder,
  }) {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl?.trim().isEmpty ?? true ? null : imageUrl?.trim(),
      'displayOrder': displayOrder,
    }..removeWhere((key, value) => value == null);
  }
}
