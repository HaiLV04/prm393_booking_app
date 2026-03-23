import 'package:prm393_booking_app/core/network/api_client.dart';

class AdminFacilityRepository {
  AdminFacilityRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<AreaItem>> getAreas() async {
    final response = await _apiClient.get('/api/areas');
    final data = _extractData(response);
    if (data is! List) {
      return const <AreaItem>[];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(AreaItem.fromJson)
        .toList();
  }

  Future<AreaItem> createArea({
    required String name,
    String description = '',
  }) async {
    final response = await _apiClient.post(
      '/api/areas',
      body: {
        'name': name,
        'description': description,
      },
    );

    final data = _extractData(response);
    if (data is! Map<String, dynamic>) {
      throw ApiException(
        message: 'Unexpected area response',
        statusCode: 500,
        body: response,
      );
    }

    return AreaItem.fromJson(data);
  }

  Future<void> updateArea({
    required int id,
    required String name,
    String description = '',
  }) async {
    await _apiClient.put(
      '/api/areas/$id',
      body: {
        'name': name,
        'description': description,
      },
    );
  }

  Future<void> toggleAreaActive({
    required int id,
    required bool isActive,
  }) async {
    await _apiClient.patch(
      '/api/areas/$id/active',
      body: {'isActive': isActive},
    );
  }

  Future<List<TableItem>> getTables({
    int? areaId,
    String? status,
    String? keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      '/api/tables',
      query: {
        if (areaId != null) 'areaId': areaId,
        if (status != null && status.isNotEmpty) 'status': status,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        'page': page,
        'pageSize': pageSize,
      },
    );

    final data = _extractData(response);
    final items = _extractItems(data);
    return items.map(TableItem.fromJson).toList();
  }

  Future<TableItem> getTableById(int id) async {
    final response = await _apiClient.get('/api/tables/$id');
    final data = _extractData(response);
    if (data is! Map<String, dynamic>) {
      throw ApiException(
        message: 'Table not found',
        statusCode: 404,
        body: response,
      );
    }

    return TableItem.fromJson(data);
  }

  Future<TableItem> createTable({
    required int areaId,
    required String name,
    required int capacity,
    required String status,
  }) async {
    final response = await _apiClient.post(
      '/api/tables',
      body: {
        'areaId': areaId,
        'name': name,
        'capacity': capacity,
        'status': status,
      },
    );

    final data = _extractData(response);
    if (data is! Map<String, dynamic>) {
      throw ApiException(
        message: 'Unexpected table response',
        statusCode: 500,
        body: response,
      );
    }

    return TableItem.fromJson(data);
  }

  Future<void> updateTable({
    required int id,
    required int areaId,
    required String name,
    required int capacity,
    required String status,
  }) async {
    await _apiClient.put(
      '/api/tables/$id',
      body: {
        'areaId': areaId,
        'name': name,
        'capacity': capacity,
        'status': status,
      },
    );
  }

  Future<void> toggleTableActive({
    required int id,
    required bool isActive,
  }) async {
    await _apiClient.patch(
      '/api/tables/$id/active',
      body: {'isActive': isActive},
    );
  }

  Future<void> changeTableStatus({
    required int id,
    required String status,
  }) async {
    await _apiClient.patch(
      '/api/tables/$id/status',
      body: {'status': status},
    );
  }

  Future<MySettingsItem> getMySettings() async {
    final response = await _apiClient.get('/api/settings/me');
    final data = _extractData(response);
    if (data is! Map<String, dynamic>) {
      throw ApiException(
        message: 'Settings not found',
        statusCode: 404,
        body: response,
      );
    }

    return MySettingsItem.fromJson(data);
  }

  Future<void> updateMySettings({
    required String fullName,
    String? phone,
    String? email,
  }) async {
    await _apiClient.put(
      '/api/settings/me',
      body: {
        'fullName': fullName,
        'phone': phone,
        'email': email,
      },
    );
  }

  dynamic _extractData(Map<String, dynamic> response) {
    if (response.containsKey('data')) {
      return response['data'];
    }
    if (response.containsKey('Data')) {
      return response['Data'];
    }
    return response;
  }

  List<Map<String, dynamic>> _extractItems(dynamic data) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }

    if (data is Map<String, dynamic>) {
      final candidates = [
        data['items'],
        data['Items'],
        data['data'],
        data['Data'],
      ];

      for (final candidate in candidates) {
        if (candidate is List) {
          return candidate.whereType<Map<String, dynamic>>().toList();
        }
      }
    }

    return const <Map<String, dynamic>>[];
  }
}

class AreaItem {
  const AreaItem({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  final int id;
  final String name;
  final String description;
  final bool isActive;

  factory AreaItem.fromJson(Map<String, dynamic> json) {
    return AreaItem(
      id: _asInt(json['id'] ?? json['Id']),
      name: _asString(json['name'] ?? json['Name']),
      description: _asString(
        json['description'] ?? json['Description'],
        fallback: '',
      ),
      isActive: _asBool(json['isActive'] ?? json['IsActive']),
    );
  }
}

class TableItem {
  const TableItem({
    required this.id,
    required this.areaId,
    required this.areaName,
    required this.name,
    required this.capacity,
    required this.status,
    required this.isActive,
  });

  final int id;
  final int areaId;
  final String areaName;
  final String name;
  final int capacity;
  final String status;
  final bool isActive;

  factory TableItem.fromJson(Map<String, dynamic> json) {
    return TableItem(
      id: _asInt(json['id'] ?? json['Id']),
      areaId: _asInt(json['areaId'] ?? json['AreaId']),
      areaName: _asString(json['areaName'] ?? json['AreaName']),
      name: _asString(json['name'] ?? json['Name']),
      capacity: _asInt(json['capacity'] ?? json['Capacity']),
      status: _asString(
        json['status'] ?? json['Status'],
        fallback: 'available',
      ),
      isActive: _asBool(json['isActive'] ?? json['IsActive']),
    );
  }
}

class MySettingsItem {
  const MySettingsItem({
    required this.userId,
    required this.fullName,
    this.phone,
    this.email,
  });

  final int userId;
  final String fullName;
  final String? phone;
  final String? email;

  factory MySettingsItem.fromJson(Map<String, dynamic> json) {
    final rawPhone = json['phone'] ?? json['Phone'];
    final rawEmail = json['email'] ?? json['Email'];
    return MySettingsItem(
      userId: _asInt(json['userId'] ?? json['UserId']),
      fullName: _asString(json['fullName'] ?? json['FullName']),
      phone: rawPhone == null ? null : rawPhone.toString(),
      email: rawEmail == null ? null : rawEmail.toString(),
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  return fallback;
}

bool _asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
  }
  return fallback;
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }
  final result = value.toString().trim();
  return result.isEmpty ? fallback : result;
}
