import 'package:flutter/material.dart';
import 'package:prm393_booking_app/shared/models/reservation.dart';
import 'package:prm393_booking_app/shared/services/reservation_service.dart';

class EditCancelReservationScreen extends StatefulWidget {
  const EditCancelReservationScreen({super.key, required this.reservation});

  final Reservation reservation;

  static const String updatedResult = 'updated';
  static const String cancelledResult = 'cancelled';

  @override
  State<EditCancelReservationScreen> createState() =>
      _EditCancelReservationScreenState();
}

class _EditCancelReservationScreenState
    extends State<EditCancelReservationScreen> {
  static const Color _primary = Color(0xFF13EC5B);
  static const Color _background = Color(0xFFF6F8F6);
  static const Color _surface = Colors.white;
  static const Color _danger = Color(0xFFEF4444);
  static const Color _border = Color(0xFFE1E7E3);
  static const Color _textPrimary = Color(0xFF17301F);
  static const Color _textSecondary = Color(0xFF6B7C73);

  late final TextEditingController _noteController;
  late int _guestCount;
  bool _isSaving = false;
  bool _isCancelling = false;

  String _normalizeReservationStatus(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized == 'pending') {
      return 'occupied';
    }
    return normalized;
  }

  bool get _canModify {
    final normalized = _normalizeReservationStatus(widget.reservation.status);
    return normalized == 'occupied';
  }

  bool get _canCancel {
    final normalized = _normalizeReservationStatus(widget.reservation.status);
    return normalized == 'occupied';
  }

  @override
  void initState() {
    super.initState();
    _guestCount = widget.reservation.guestCount <= 0
        ? 1
        : widget.reservation.guestCount;
    _noteController = TextEditingController(
      text: widget.reservation.note?.trim() ?? '',
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_canModify || _isSaving || _isCancelling) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ReservationService.updateReservation(
        id: widget.reservation.id,
        tableId: widget.reservation.tableId,
        customerName: widget.reservation.customerName,
        customerPhone: widget.reservation.customerPhone,
        guestCount: _guestCount,
        status: widget.reservation.status,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu thay đổi')),
      );
      Navigator.of(context).pop(EditCancelReservationScreen.updatedResult);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _cancelReservation() async {
    if (!_canCancel || _isSaving || _isCancelling) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _surface,
          title: const Text(
            'Hủy check-in',
            style: TextStyle(color: _textPrimary),
          ),
          content: const Text(
            'Bạn có chắc muốn hủy check-in này không?',
            style: TextStyle(color: _textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Đóng'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: _danger,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xác nhận hủy'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isCancelling = true;
    });

    try {
      await ReservationService.cancelReservation(widget.reservation.id);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã hủy check-in')),
      );
      Navigator.of(context).pop(EditCancelReservationScreen.cancelledResult);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCancelling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _isSaving || _isCancelling;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
        ),
        centerTitle: true,
        title: const Text(
          'Cập nhật check-in',
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Số lượng khách',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildGuestButton(
                                icon: Icons.remove,
                                onTap: !_canModify || isBusy || _guestCount <= 1
                                    ? null
                                    : () {
                                        setState(() {
                                          _guestCount -= 1;
                                        });
                                      },
                              ),
                              const SizedBox(width: 28),
                              SizedBox(
                                width: 44,
                                child: Text(
                                  '$_guestCount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 28),
                              _buildGuestButton(
                                icon: Icons.add,
                                onTap: !_canModify || isBusy || _guestCount >= 100
                                    ? null
                                    : () {
                                        setState(() {
                                          _guestCount += 1;
                                        });
                                      },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Ghi chú',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _noteController,
                      enabled: _canModify && !isBusy,
                      maxLines: 5,
                      minLines: 5,
                      style: const TextStyle(color: _textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Nhập ghi chú (VD: Dị ứng, ghế trẻ em...)',
                        hintStyle: TextStyle(
                          color: _textSecondary,
                        ),
                        filled: true,
                        fillColor: _surface,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: _border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: _border),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: _border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: _primary),
                        ),
                      ),
                    ),
                    if (!_canModify) ...[
                      const SizedBox(height: 14),
                      Text(
                        'Chỉ reservation đang dùng mới được chỉnh sửa hoặc hủy.',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: _background,
                border: Border(
                  top: const BorderSide(color: _border),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canModify && !isBusy ? _saveChanges : null,
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
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Lưu thay đổi',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _canCancel && !isBusy ? _cancelReservation : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _danger,
                        side: BorderSide(color: _danger.withValues(alpha: 0.24)),
                        backgroundColor: _danger.withValues(alpha: 0.08),
                        disabledForegroundColor: const Color(0xFF916261),
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: _isCancelling
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Hủy check-in',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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

  Widget _buildGuestButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: onTap == null
              ? _primary.withValues(alpha: 0.06)
              : _primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(
          icon,
          color: onTap == null
              ? _primary.withValues(alpha: 0.35)
              : _primary,
          size: 24,
        ),
      ),
    );
  }
}