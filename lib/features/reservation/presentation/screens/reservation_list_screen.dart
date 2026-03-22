import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/reservation/presentation/screens/edit_cancel_reservation_screen.dart';
import 'package:prm393_booking_app/features/reservation/presentation/screens/reservation_detail_screen.dart';
import '../../../../../shared/models/reservation.dart';
import '../../../../../shared/services/reservation_service.dart';

class ReservationListScreen extends StatefulWidget {
  const ReservationListScreen({super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF13EC5B);
  static const Color _background = Color(0xFFF6F8F6);
  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFE1E7E3);
  static const Color _textPrimary = Color(0xFF17301F);
  static const Color _textSecondary = Color(0xFF6B7C73);

  late TabController _tabController;

  late Future<List<Reservation>> futureReservations;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    futureReservations = _loadReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _normalizeReservationStatus(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized == 'pending') {
      return 'occupied';
    }
    return normalized;
  }

  List<Reservation> filter(List<Reservation> list, int index) {
    if (index == 0) {
      return list
          .where((r) => _normalizeReservationStatus(r.status) == 'occupied')
          .toList();
    }
    if (index == 1) {
      return list
          .where((r) => _normalizeReservationStatus(r.status) == 'completed')
          .toList();
    }
    return list
        .where((r) => _normalizeReservationStatus(r.status) == 'cancelled')
        .toList();
  }

  String getStatusText(String status) {
    switch (_normalizeReservationStatus(status)) {
      case "occupied":
        return "Đang dùng";
      case "completed":
        return "Hoàn thành";
      case "cancelled":
        return "Đã hủy";
      default:
        return "";
    }
  }

  Color getStatusColor(String status) {
    switch (_normalizeReservationStatus(status)) {
      case "occupied":
        return Colors.green;
      case "completed":
        return Colors.blue;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  List<Reservation> _filterBySearch(List<Reservation> list) {
    if (_searchQuery.trim().isEmpty) {
      return list;
    }

    final normalizedQuery = _searchQuery.trim().toLowerCase();
    return list
        .where((reservation) =>
            reservation.tableName.toLowerCase().contains(normalizedQuery))
        .toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  Future<List<Reservation>> _loadReservations() {
    return ReservationService.getReservations();
  }

  void _retryLoad() {
    setState(() {
      futureReservations = _loadReservations();
    });
  }

  void _goBackToDashboard() {
    Navigator.of(context).pushReplacementNamed('/staff/dashboard');
  }

  Widget _buildErrorState(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    final isAuthError = message.contains('Phiên đăng nhập');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAuthError ? Icons.lock_outline : Icons.cloud_off,
              color: _textSecondary,
              size: 34,
            ),
            const SizedBox(height: 12),
            Text(
              isAuthError ? 'Cần đăng nhập lại' : 'Không tải được danh sách đặt chỗ',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _retryLoad,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13EC5B),
                    foregroundColor: const Color(0xFF08110B),
                  ),
                  child: const Text('Thử lại'),
                ),
                if (isAuthError)
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _border),
                      foregroundColor: _textPrimary,
                    ),
                    child: const Text('Đăng nhập'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _textPrimary,
        iconTheme: const IconThemeData(color: _textPrimary),
        leading: IconButton(
          onPressed: _goBackToDashboard,
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Quay lại dashboard',
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên bàn',
                  hintStyle: const TextStyle(color: _textSecondary, fontSize: 15),
                  border: InputBorder.none,
                ),
              )
            : const Text(
                'Quản lý check-in',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: _border,
          dividerHeight: 1,
          labelColor: _primary,
          unselectedLabelColor: _textSecondary,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Đang dùng'),
            Tab(text: 'Hoàn thành'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),

      body: FutureBuilder<List<Reservation>>(
        future: futureReservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error!);
          }

          final reservations = snapshot.data!;

          return TabBarView(
            controller: _tabController,
            children: [
              buildList(_filterBySearch(filter(reservations, 0))),
              buildList(_filterBySearch(filter(reservations, 1))),
              buildList(_filterBySearch(filter(reservations, 2))),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF13EC5B),
        onPressed: () async {
          final created = await Navigator.of(context).pushNamed('/create_reservations');
          if (created == true) {
            _retryLoad();
          }
        },
        child: const Icon(Icons.add, color: Colors.black),
        tooltip: 'Check-in khách',
      ),
    );
  }

  Widget buildList(List<Reservation> list) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isEmpty
              ? 'Không có reservation nào'
              : 'Không tìm thấy bàn phù hợp',
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final r = list[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: _surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                final result = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (_) => ReservationDetailScreen(reservation: r),
                  ),
                );

                if (!mounted) {
                  return;
                }

                if (result == EditCancelReservationScreen.updatedResult ||
                    result == EditCancelReservationScreen.cancelledResult) {
                  _retryLoad();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF13EC5B).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.table_restaurant,
                        color: Color(0xFF13EC5B),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_formatTime(r.checkInTime)} - ${r.tableName}",
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Text(
                            "${r.guestCount} khách",
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          Text(
                            "${r.customerName} - ${r.customerPhone}",
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(r.status).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusText(r.status),
                        style: TextStyle(
                          color: getStatusColor(r.status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}