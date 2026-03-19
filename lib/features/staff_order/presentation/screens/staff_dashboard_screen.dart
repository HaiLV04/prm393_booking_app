import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_theme.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  final StaffOrderRepository _repository = StaffOrderRepository();
  late Future<_DashboardVm> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _loadDashboard();
  }

  Future<_DashboardVm> _loadDashboard() async {
    final reservations = await _repository.getReservations();
    final tables = await _repository.getTables();
    final activeContext = await _repository.getActiveContext();

    final today = DateTime.now();
    final todayCount = reservations.where((reservation) {
      final created = reservation.createdAt;
      return created.year == today.year &&
          created.month == today.month &&
          created.day == today.day;
    }).length;

    final servingCount = reservations.where((reservation) {
      final status = reservation.status.toLowerCase();
      return status != 'cancelled' && reservation.orderId != null;
    }).length;

    final occupiedTables = tables
        .where((table) => table.status.toLowerCase() == 'occupied')
        .length;
    final capacity = tables.isEmpty ? 0 : (occupiedTables / tables.length * 100).round();

    final latest = List<ReservationData>.from(reservations)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return _DashboardVm(
      todayCount: todayCount,
      servingCount: servingCount,
      capacityPercent: capacity,
      activeContext: activeContext,
      notices: latest.take(3).toList(),
    );
  }

  void _openOrder(StaffOrderContext? context) {
    if (context == null) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text('Khong tim thay ban dang phuc vu de goi mon.')),
      );
      return;
    }
    Navigator.pushNamed(this.context, '/staff/order', arguments: context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? StaffTheme.backgroundDark : StaffTheme.backgroundLight;
    final cardColor = isDark ? StaffTheme.cardDark : Colors.white;
    final borderColor = isDark ? StaffTheme.borderDark : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: FutureBuilder<_DashboardVm>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Khong tai duoc du lieu dashboard', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('${snapshot.error}', textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => setState(() => _dashboardFuture = _loadDashboard()),
                        child: const Text('Thu lai'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final vm = snapshot.data!;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: StaffTheme.primary.withValues(alpha: 0.3), width: 2),
                            ),
                            child: const Icon(Icons.person_outline),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nhan vien', style: GoogleFonts.inter(fontSize: 11, color: mutedColor, fontWeight: FontWeight.w600)),
                                Text('Man hinh order', style: GoogleFonts.inter(fontSize: 17, color: titleColor, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _dashboardFuture = _loadDashboard()),
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.analytics_outlined, color: StaffTheme.primary, size: 18),
                                    const SizedBox(width: 8),
                                    Text('TINH TRANG HIEN TAI', style: GoogleFonts.inter(fontSize: 11, color: StaffTheme.primary, fontWeight: FontWeight.w700, letterSpacing: 1)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Hom nay: ${vm.todayCount} ban da dat | ${vm.servingCount} ban dang phuc vu',
                                  style: GoogleFonts.inter(fontSize: 20, height: 1.3, color: titleColor, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 14),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: (vm.capacityPercent / 100).clamp(0, 1),
                                    minHeight: 8,
                                    backgroundColor: borderColor,
                                    color: StaffTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text('Cong suat: ${vm.capacityPercent}%', style: GoogleFonts.inter(fontSize: 13, color: mutedColor)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('Loi tat nhanh', style: GoogleFonts.inter(fontSize: 16, color: titleColor, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.15,
                            children: [
                              _actionCard(cardColor, borderColor, Icons.table_restaurant, 'So do ban', () {}),
                              _actionCard(cardColor, borderColor, Icons.event_available, 'Dat cho moi', () {}),
                              _actionCard(cardColor, borderColor, Icons.restaurant_menu, 'Thuc don', () => _openOrder(vm.activeContext)),
                              _actionCard(cardColor, borderColor, Icons.bar_chart, 'Thong ke', () {}),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Thong bao moi nhat', style: GoogleFonts.inter(fontSize: 16, color: titleColor, fontWeight: FontWeight.w700)),
                              TextButton(onPressed: () {}, child: const Text('Xem tat ca')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          for (final notice in vm.notices)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  if (notice.orderId != null) {
                                    Navigator.pushNamed(
                                      context,
                                      '/staff/order-detail',
                                      arguments: StaffOrderContext(
                                        tableId: notice.tableId,
                                        tableName: notice.tableName,
                                        reservationId: notice.id,
                                        orderId: notice.orderId!,
                                        guestCount: notice.guestCount,
                                        checkInTime: notice.checkInTime,
                                        customerName: notice.customerName,
                                      ),
                                    );
                                  }
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(color: StaffTheme.primary.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(10)),
                                        child: const Icon(Icons.receipt_long, color: StaffTheme.primary),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${notice.tableName} vua dat mon', style: GoogleFonts.inter(color: titleColor, fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 2),
                                            Text('${notice.customerName} - ${notice.guestCount} khach', style: GoogleFonts.inter(color: mutedColor, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ],
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
          },
        ),
      ),
    );
  }

  Widget _actionCard(
    Color cardColor,
    Color borderColor,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: StaffTheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(icon, color: StaffTheme.primary),
            ),
            const SizedBox(height: 10),
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _DashboardVm {
  const _DashboardVm({
    required this.todayCount,
    required this.servingCount,
    required this.capacityPercent,
    required this.activeContext,
    required this.notices,
  });

  final int todayCount;
  final int servingCount;
  final int capacityPercent;
  final StaffOrderContext? activeContext;
  final List<ReservationData> notices;
}
