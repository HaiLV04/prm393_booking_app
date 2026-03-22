import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prm393_booking_app/core/network/app_config.dart';
import 'package:prm393_booking_app/core/network/auth_storage.dart';

class ApiClient {
  ApiClient({http.Client? httpClient, AuthStorage? authStorage})
    : _httpClient = httpClient ?? http.Client(),
      _authStorage = authStorage ?? AuthStorage();

  final http.Client _httpClient;
  final AuthStorage _authStorage;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(path, query);
    final headers = await _buildHeaders(requiresAuth: requiresAuth);
    final response = await _httpClient.get(uri, headers: headers);
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(path, query);
    final headers = await _buildHeaders(requiresAuth: requiresAuth);
    final response = await _httpClient.post(
      uri,
      headers: headers,
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _decodeResponse(response);
  }

  Uri _buildUri(String path, Map<String, dynamic>? query) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final base = Uri.parse(AppConfig.apiBaseUrl);
    return base.replace(
      path: normalizedPath,
      queryParameters: query?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Future<Map<String, String>> _buildHeaders({
    required bool requiresAuth,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (requiresAuth) {
      final token = await _authStorage.getToken();
      if (token?.isNotEmpty ?? false) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final raw = response.body;
    final json = raw.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(raw) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }

    throw ApiException(
      message: (json['message'] ?? 'Request failed').toString(),
      statusCode: response.statusCode,
      body: json,
    );
  }
}

class ApiException implements Exception {
  ApiException({required this.message, required this.statusCode, required this.body});

  final String message;
  final int statusCode;
  final Map<String, dynamic> body;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
