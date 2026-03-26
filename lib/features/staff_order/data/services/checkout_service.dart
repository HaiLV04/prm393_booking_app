import 'package:prm393_booking_app/core/network/api_client.dart';

/// CheckoutService: Handles payment checkout and invoice creation
/// Backend endpoint base: /api/checkout
class CheckoutService {
  final ApiClient _apiClient;

  CheckoutService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// POST /api/checkout
  /// Request: {
  ///   orderId (required),
  ///   paymentMethod (required: 'cash' | 'card' | 'qr_transfer'),
  ///   taxAmount (optional, default: 0),
  ///   discountAmount (optional, default: 0),
  ///   tipAmount (optional, default: 0)
  /// }
  /// Response: { success, message, data: { id, orderId, staffId, paymentMethod, taxAmount, discountAmount, tipAmount, finalTotal, paidAt } }
  /// Requires: Authorization header with token (staff or admin role)
  Future<Map<String, dynamic>> checkout({
    required int orderId,
    required String paymentMethod,
    double taxAmount = 0,
    double discountAmount = 0,
    double tipAmount = 0,
  }) async {
    // Validate payment method
    const validMethods = {'cash', 'card', 'qr_transfer'};
    if (!validMethods.contains(paymentMethod)) {
      throw ApiException(
        message:
            'Invalid payment method. Must be one of: cash, card, qr_transfer',
        statusCode: 400,
        body: {},
      );
    }

    return await _apiClient.post(
      '/checkout',
      body: {
        'orderId': orderId,
        'paymentMethod': paymentMethod,
        'taxAmount': taxAmount,
        'discountAmount': discountAmount,
        'tipAmount': tipAmount,
      },
      requiresAuth: true,
    );
  }
}
