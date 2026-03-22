import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/core/network/auth_storage.dart';

/// AuthService: Handles authentication API calls (login, register, change password)
/// Backends endpoint base: /api/auth
class AuthService {
  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  AuthService({
    required ApiClient apiClient,
    required AuthStorage authStorage,
  })  : _apiClient = apiClient,
        _authStorage = authStorage;

  /// POST /api/auth/login
  /// Request: { username, password }
  /// Response: { success, message, data: { token, expiresAt, user: { id, username, role, ... } } }
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {
        'username': username,
        'password': password,
      },
      requiresAuth: false,
    );

    // Extract token from response and save it
    if (response['success'] == true && response['data'] != null) {
      final token = response['data']['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await _authStorage.saveToken(token);
      }
    }

    return response;
  }

  /// POST /api/auth/register
  /// Request: { fullName, username, password, email?, phone?, role? }
  /// Response: { success, message, data: { token, expiresAt, user: {...} } }
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String username,
    required String password,
    String? email,
    String? phone,
    String role = 'staff',
  }) async {
    final response = await _apiClient.post(
      '/auth/register',
      body: {
        'fullName': fullName,
        'username': username,
        'password': password,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        'role': role,
      },
      requiresAuth: false,
    );

    // Extract token from response and save it
    if (response['success'] == true && response['data'] != null) {
      final token = response['data']['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await _authStorage.saveToken(token);
      }
    }

    return response;
  }

  /// POST /api/auth/change-password
  /// Request: { currentPassword, newPassword }
  /// Response: { success, message }
  /// Requires: Authorization header with token
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _apiClient.post(
      '/auth/change-password',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
      requiresAuth: true,
    );
  }

  /// GET /api/auth/me
  /// Response: { success, message, data: { id, username, role, email, phone, fullName, isActive, createdAt } }
  /// Requires: Authorization header with token
  Future<Map<String, dynamic>> getMe() async {
    return await _apiClient.get(
      '/auth/me',
      requiresAuth: true,
    );
  }

  /// Clear stored token (logout)
  Future<void> logout() async {
    await _authStorage.clearToken();
  }

  /// Get stored token
  Future<String?> getToken() async {
    return await _authStorage.getToken();
  }
}
