import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AdminMediaRepository {
  static const String _tableImagesKey = 'admin_table_images_v1';
  static const String _areaImagesKey = 'admin_area_images_v1';

  Future<Map<int, String>> getTableImages() => _readMap(_tableImagesKey);

  Future<Map<int, String>> getAreaImages() => _readMap(_areaImagesKey);

  Future<String?> getTableImage(int tableId) async {
    final images = await _readMap(_tableImagesKey);
    return images[tableId];
  }

  Future<String?> getAreaImage(int areaId) async {
    final images = await _readMap(_areaImagesKey);
    return images[areaId];
  }

  Future<void> setTableImage(int tableId, String imageUrl) async {
    await _setImage(_tableImagesKey, tableId, imageUrl);
  }

  Future<void> setAreaImage(int areaId, String imageUrl) async {
    await _setImage(_areaImagesKey, areaId, imageUrl);
  }

  Future<void> _setImage(String key, int id, String imageUrl) async {
    final map = await _readMap(key);
    final value = imageUrl.trim();
    if (value.isEmpty) {
      map.remove(id);
    } else {
      map[id] = value;
    }
    await _writeMap(key, map);
  }

  Future<Map<int, String>> _readMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return <int, String>{};
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final result = <int, String>{};
      decoded.forEach((k, v) {
        final parsed = int.tryParse(k);
        if (parsed != null && v != null) {
          result[parsed] = v.toString();
        }
      });
      return result;
    } catch (_) {
      return <int, String>{};
    }
  }

  Future<void> _writeMap(String key, Map<int, String> map) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(map.map((k, v) => MapEntry(k.toString(), v)));
    await prefs.setString(key, encoded);
  }
}
