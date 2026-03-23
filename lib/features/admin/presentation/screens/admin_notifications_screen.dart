import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';
import 'package:prm393_booking_app/core/models/admin_notification.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/services/admin_notification_service.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  late final AdminNotificationService _notificationService;
  Timer? _pollingTimer;

  bool _isLoading = true;
  String? _error;
  List<AdminNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _notificationService = AdminNotificationService(apiClient: ApiClient());
    _loadNotifications(showLoading: true);
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _loadNotifications(showLoading: false);
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadNotifications({required bool showLoading}) async {
    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final items = await _notificationService.getMyNotifications();
      if (!mounted) {
        return;
      }

      setState(() {
        _notifications = items;
        _isLoading = false;
        _error = null;
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _error = 'Không thể tải thông báo. Vui lòng thử lại.';
      });
    }
  }

  Future<void> _markAsRead(AdminNotification item) async {
    if (item.isRead) {
      return;
    }

    try {
      await _notificationService.markAsRead(item.id);
      if (!mounted) {
        return;
      }

      setState(() {
        _notifications = _notifications
            .map((n) => n.id == item.id
                ? AdminNotification(
                    id: n.id,
                    content: n.content,
                    isRead: true,
                    createdAt: n.createdAt,
                  )
                : n)
            .toList();
      });
    } catch (_) {
      // Keep silent to avoid interrupting reading notifications.
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.backgroundLight;
    final textMain = AppColors.textMain;
    final textSub = AppColors.textSub;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'Thông báo',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textMain,
          ),
        ),
        backgroundColor: bg,
        elevation: 0,
        iconTheme: IconThemeData(color: textMain),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState(textSub)
              : RefreshIndicator(
                  onRefresh: () => _loadNotifications(showLoading: false),
                  child: _notifications.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 140),
                            Icon(
                              Icons.notifications_none_rounded,
                              size: 44,
                              color: textSub,
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                'Chưa có thông báo nào',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: textSub,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          itemCount: _notifications.length,
                          separatorBuilder: (_, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = _notifications[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _markAsRead(item),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: item.isRead
                                      ? Colors.white
                                      : AppColors.primary.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: item.isRead
                                        ? AppColors.textSub.withOpacity(0.22)
                                        : AppColors.primary.withOpacity(0.18),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 6),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: item.isRead
                                            ? Colors.transparent
                                            : AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.content,
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: item.isRead
                                                  ? FontWeight.w500
                                                  : FontWeight.w600,
                                              color: textMain,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            _formatTime(item.createdAt),
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: textSub,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }

  Widget _buildErrorState(Color textSub) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: textSub, size: 30),
            const SizedBox(height: 10),
            Text(
              _error ?? 'Có lỗi xảy ra',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: textSub),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _loadNotifications(showLoading: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute $day/$month/$year';
  }
}
