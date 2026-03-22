import 'package:prm393_booking_app/core/network/api_client.dart';
import '../models/reservation.dart';

class ReservationService {
  static final ApiClient _apiClient = ApiClient();

  /// GET: /api/reservations
  static Future<List<Reservation>> getReservations() async {
    try {
      final jsonResponse = await _apiClient.get(
        '/api/reservations',
        query: {'page': 1, 'pageSize': 100},
      );

      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        final data = jsonResponse['data'];

        if (data is List) {
          return data.map((e) => Reservation.fromJson(e)).toList();
        }
        if (data is Map && data['items'] != null) {
          final List items = data['items'];
          return items.map((e) => Reservation.fromJson(e)).toList();
        }

        throw Exception('Format lỗi: data không phải array');
      }

      throw Exception('API lỗi: ${jsonResponse['message']}');
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Phiên đăng nhập không hợp lệ hoặc đã hết hạn');
      }
      throw Exception('API lỗi: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  /// GET: /api/reservations/{id}
  static Future<Reservation> getReservationById(int id) async {
    try {
      final json = await _apiClient.get('/api/reservations/$id');
      final data = json['data'];
      if (data is Map<String, dynamic>) {
        return Reservation.fromJson(data);
      }
      throw Exception('Không lấy được chi tiết');
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Phiên đăng nhập không hợp lệ hoặc đã hết hạn');
      }
      throw Exception('API lỗi: ${e.message}');
    }
  }

  /// POST: /api/reservations/check-in
  static Future<void> createReservation({
    required int tableId,
    required String customerName,
    required String customerPhone,
    required int guestCount,
    required DateTime checkInTime,
    String? note,
  }) async {
    try {
      await _apiClient.post(
        '/api/reservations/check-in',
        body: {
          'tableId': tableId,
          'customerName': customerName,
          'customerPhone': customerPhone,
          'guestCount': guestCount,
          'checkInTime': checkInTime.toIso8601String(),
          'note': note,
        },
      );
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Phiên đăng nhập không hợp lệ hoặc đã hết hạn');
      }
      throw Exception('API lỗi: ${e.message}');
    }
  }

  /// PUT: /api/reservations/{id}
  static Future<void> updateReservation({
    required int id,
    required int tableId,
    required String customerName,
    required String customerPhone,
    required int guestCount,
    String? status,
    String? note,
  }) async {
    try {
      await _apiClient.put(
        '/api/reservations/$id',
        body: {
          'tableId': tableId,
          'customerName': customerName,
          'customerPhone': customerPhone,
          'guestCount': guestCount,
          'status': status,
          'note': note,
        },
      );
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Phiên đăng nhập không hợp lệ hoặc đã hết hạn');
      }
      throw Exception('API lỗi: ${e.message}');
    }
  }

  /// PATCH: /api/reservations/{id}/cancel
  static Future<void> cancelReservation(int id) async {
    try {
      await _apiClient.patch('/api/reservations/$id/cancel');
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Phiên đăng nhập không hợp lệ hoặc đã hết hạn');
      }
      throw Exception('API lỗi: ${e.message}');
    }
  }
}