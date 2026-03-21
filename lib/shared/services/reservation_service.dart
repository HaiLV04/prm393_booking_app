import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/reservation.dart';

class ReservationService {
  // ✅ Tự động chọn URL phù hợp tùy theo platform
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5200/api"; // Web
    } else {
      return "http://10.0.2.2:5200/api"; // Android emulator
      // Nếu chạy trên thiết bị thật, thay bằng: return "http://192.168.x.x:5200/api";
    }
  }

  /// GET: /api/reservations
  static Future<List<Reservation>> getReservations() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/reservations"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        
        // ✅ Parse response: {success, data: [...] hoặc {items: [...]}}
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          
          // Nếu data là array trực tiếp
          if (data is List) {
            return data.map((e) => Reservation.fromJson(e)).toList();
          }
          // Nếu data là object với items property (paged result)
          else if (data is Map && data['items'] != null) {
            final List items = data['items'];
            return items.map((e) => Reservation.fromJson(e)).toList();
          }
          
          throw Exception("Format lỗi: data không phải array");
        } else {
          throw Exception("API lỗi: ${jsonResponse['message']}");
        }
      } else {
        throw Exception("API lỗi: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }

  /// GET: /api/reservations/{id}
  static Future<Reservation> getReservationById(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/reservations/$id"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Reservation.fromJson(data);
    } else {
      throw Exception("Không lấy được chi tiết");
    }
  }

  /// POST: /api/reservations/check-in
  static Future<void> createReservation({
    required int tableId,
    required String customerName,
    required String customerPhone,
    required int guestCount,
    String? note,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reservations/check-in"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "tableId": tableId,
        "customerName": customerName,
        "customerPhone": customerPhone,
        "guestCount": guestCount,
        "note": note,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Tạo reservation thất bại: ${response.body}");
    }
  }

  /// PATCH: /api/reservations/{id}/cancel
  static Future<void> cancelReservation(int id) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/reservations/$id/cancel"),
    );

    if (response.statusCode != 200) {
      throw Exception("Hủy thất bại");
    }
  }
}