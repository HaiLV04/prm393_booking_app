import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/reservation/presentation/screens/edit_cancel_reservation_screen.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/shared/models/reservation.dart';

class ReservationDetailScreen extends StatelessWidget {
  const ReservationDetailScreen({super.key, required this.reservation});

  final Reservation reservation;

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _background = Color(0xFFF6F8F6);
  static const Color _surface = Colors.white;
  static const Color _surfaceHover = Color(0xFFE1E7E3);
  static const Color _textPrimary = Color(0xFF17301F);
  static const Color _textSecondary = Color(0xFF6B7C73);

  String _formatTime(DateTime value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year} ${_formatTime(value)}';
  }

  String _displayTableName(String rawName) {
    return rawName.replaceFirst('Table', 'Bàn');
  }

  String _normalizeReservationStatus(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized == 'pending') {
      return 'occupied';
    }
    return normalized;
  }

  String _statusText(String status) {
    switch (_normalizeReservationStatus(status)) {
      case 'occupied':
        return 'Đang dùng';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  Color _statusBackground(String status) {
    switch (_normalizeReservationStatus(status)) {
      case 'occupied':
        return const Color(0xFF0F4F29);
      case 'completed':
        return const Color(0xFF143B6B);
      case 'cancelled':
        return const Color(0xFF5B1B1B);
      default:
        return const Color(0xFF374151);
    }
  }

  Color _statusForeground(String status) {
    switch (_normalizeReservationStatus(status)) {
      case 'occupied':
        return const Color(0xFF4ADE80);
      case 'completed':
        return const Color(0xFF60A5FA);
      case 'cancelled':
        return const Color(0xFFF87171);
      default:
        return _textSecondary;
    }
  }

  StaffOrderContext? _buildOrderContext() {
    final orderId = reservation.orderId;
    if (orderId == null) {
      return null;
    }

    return StaffOrderContext(
      tableId: reservation.tableId,
      tableName: reservation.tableName,
      reservationId: reservation.id,
      orderId: orderId,
      guestCount: reservation.guestCount,
      checkInTime: reservation.checkInTime,
      customerName: reservation.customerName,
    );
  }

  bool get _canOpenOrder => _buildOrderContext() != null;

  bool get _canCheckout {
    final normalized = _normalizeReservationStatus(reservation.status);
    return reservation.orderId != null && normalized == 'occupied';
  }

  bool get _canEditOrCancel {
    final normalized = _normalizeReservationStatus(reservation.status);
    return normalized == 'occupied';
  }

  @override
  Widget build(BuildContext context) {
    final orderContext = _buildOrderContext();
    final noteText = reservation.note?.trim() ?? '';

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
        ),
        title: const Text(
          'Chi tiết check-in',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _surfaceHover),
                      ),
                      child: Column(
                        children: [
                          _buildTableHeader(),
                          _divider(),
                          _buildInfoRow(
                            icon: Icons.schedule,
                            value: _formatTime(reservation.checkInTime),
                            label: 'Time',
                          ),
                          _divider(),
                          _buildStatusRow(),
                          _divider(),
                          _buildInfoRow(
                            icon: Icons.call,
                            value: reservation.customerPhone.isEmpty
                                ? 'Chưa có số điện thoại'
                                : reservation.customerPhone,
                            label: 'Phone',
                          ),
                          _divider(),
                          _buildInfoRow(
                            icon: Icons.person,
                            value: reservation.staffName.isEmpty
                                ? 'Chưa phân công'
                                : reservation.staffName,
                            label: 'Staff',
                          ),
                          _divider(),
                          _buildInfoRow(
                            icon: Icons.event,
                            value: _formatDateTime(reservation.createdAt),
                            label: 'Created',
                          ),
                        ],
                      ),
                    ),
                    if (noteText.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildNoteCard(noteText),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              decoration: const BoxDecoration(
                color: _background,
                border: Border(top: BorderSide(color: _surfaceHover)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _canEditOrCancel
                          ? () async {
                              final result = await Navigator.of(context).push<String>(
                                MaterialPageRoute(
                                  builder: (_) => EditCancelReservationScreen(
                                    reservation: reservation,
                                  ),
                                ),
                              );

                              if (!context.mounted) {
                                return;
                              }

                              if (result == EditCancelReservationScreen.updatedResult ||
                                  result == EditCancelReservationScreen.cancelledResult) {
                                Navigator.of(context).pop(result);
                              }
                            }
                          : null,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Cập nhật hoặc hủy'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _textPrimary,
                        side: const BorderSide(color: _surfaceHover),
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _canOpenOrder
                          ? () {
                              Navigator.pushNamed(
                                context,
                                '/staff/order',
                                arguments: orderContext,
                              );
                            }
                          : null,
                      icon: const Icon(Icons.restaurant_menu),
                      label: const Text('Gọi món'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: const Color(0xFF102216),
                        disabledBackgroundColor: const Color(0xFFD4E7DA),
                        disabledForegroundColor: const Color(0xFF8AA295),
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _canCheckout
                          ? () {
                              Navigator.pushNamed(
                                context,
                                '/staff/order-detail',
                                arguments: orderContext,
                              );
                            }
                          : null,
                      icon: const Icon(Icons.payments),
                      label: const Text('Thanh toán'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F4F1),
                        foregroundColor: _textPrimary,
                        disabledBackgroundColor: const Color(0xFFF0F4F1),
                        disabledForegroundColor: const Color(0xFF9AA9A1),
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.table_restaurant, color: _primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayTableName(reservation.tableName),
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Bàn',
                  style: TextStyle(color: _textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.group, size: 16, color: _textSecondary),
          const SizedBox(width: 4),
          Text(
            '${reservation.guestCount} khách',
            style: const TextStyle(color: _textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _surfaceHover,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _textSecondary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: _textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _surfaceHover,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.info, color: _textSecondary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusBackground(reservation.status),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _statusText(reservation.status),
                  style: TextStyle(
                    color: _statusForeground(reservation.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const Text(
            'Status',
            style: TextStyle(color: _textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(String noteText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _surfaceHover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.sticky_note_2_outlined, color: _textSecondary, size: 18),
              SizedBox(width: 8),
              Text(
                'Ghi chú',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            noteText,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, color: _surfaceHover);
  }
}