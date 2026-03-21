import 'package:flutter/material.dart';
import '../../../../../shared/models/reservation.dart';
import '../../../../../shared/services/reservation_service.dart';

class ReservationListScreen extends StatefulWidget {
  const ReservationListScreen({super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Future<List<Reservation>> futureReservations;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    futureReservations = ReservationService.getReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Reservation> filter(List<Reservation> list, int index) {
    if (index == 0) {
      return list
          .where((r) => r.status == "pending" || r.status == "occupied")
          .toList();
    }
    if (index == 1) {
      return list.where((r) => r.status == "completed").toList();
    }
    return list.where((r) => r.status == "cancelled").toList();
  }

  String getStatusText(String status) {
    switch (status) {
      case "pending":
        return "Chờ phục vụ";
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
    switch (status) {
      case "pending":
        return Colors.orange;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102216),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102216),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên bàn',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                ),
              )
            : const Text(
                'Đặt chỗ',
                style: TextStyle(
                  color: Colors.white,
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
          indicatorColor: const Color(0xFF13EC5B),
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: const Color(0xFF455648),
          dividerHeight: 1,
          labelColor: const Color(0xFF13EC5B),
          unselectedLabelColor: Colors.white.withValues(alpha: 0.55),
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
            return Center(child: Text("Error: ${snapshot.error}"));
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
            setState(() {
              futureReservations = ReservationService.getReservations();
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.black),
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
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2E21),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2A4230)),
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
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      "${r.guestCount} khách",
                      style: const TextStyle(
                        color: Color(0xFFB7C3BA),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      "${r.customerName} - ${r.customerPhone}",
                      style: const TextStyle(
                        color: Color(0xFFB7C3BA),
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
        );
      },
    );
  }
}