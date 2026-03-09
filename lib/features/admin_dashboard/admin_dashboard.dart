import 'package:flutter/material.dart';
import 'admin_dashboard_styles.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = AdminDashboardStyles.background(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg.withOpacity(0.9),
        elevation: 0,
        centerTitle: false,
        title: Text('Dashboard', style: AdminDashboardStyles.headerTitle(context)),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          Stack(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
              Positioned(top: 10, right: 10, child: CircleAvatar(radius: 4, backgroundColor: Colors.red,))
            ],
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBLPChzwG5pOdg0rNExb7fL3lTfgiLK-HSqp4SOeeO2_ku4f8AQ7nJ5llbbbo4Re56znVvrQXwrsd5kjgM4_tCopsEMqt1OACrXPZvZZWU9nFjndtZdyKh1Uc4A5a4feBsRb7lzGnRMq9ElAHmNjUL3h5O7NDhXRp4IZ7-yqYYm6fYc5NdJGGuWV1oMWK3zKKpcRmPLMxkuqNhJSLj0M7oVgepo4ZTXNH8buIeoy3LCK--jzXHW1HOeexQUj8qYXABryqV8rc-9Q_Y'),
                      ),
                      border: Border.all(color: AdminDashboardStyles.primary.withOpacity(0.12), width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome, Admin', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text('PRM393 Restaurant Manager', style: AdminDashboardStyles.smallMuted(context)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary cards (2 columns)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _summaryCard(context, 'Tổng bàn', '8', Icons.table_restaurant, null),
                  _summaryCard(context, 'Đang dùng', '3', Icons.groups, Colors.orange),
                  _summaryCard(context, 'Order hôm nay', '12', Icons.receipt_long, Colors.blue),
                  _summaryCard(context, 'Doanh thu', '5.2M', Icons.payments, AdminDashboardStyles.primary),
                ],
              ),
              const SizedBox(height: 16),

              // Quick actions
              Text('Quick Actions', style: AdminDashboardStyles.headerTitle(context)),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _iconAction(context, Icons.bar_chart, 'Thống kê'),
                  _iconAction(context, Icons.badge, 'Nhân viên'),
                  _iconAction(context, Icons.map, 'Khu vực'),
                  _iconAction(context, Icons.settings, 'Cài đặt'),
                ],
              ),
              const SizedBox(height: 16),

              // Recent reservations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Reservations', style: AdminDashboardStyles.headerTitle(context)),
                  TextButton(onPressed: () {}, child: Text('View All', style: TextStyle(color: AdminDashboardStyles.primary)))
                ],
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  _reservationItem(context, 'T2', 'Table 2 - 4 Pax', 'Today, 19:00 • Nguyen Van A', 'Pending', Colors.orange),
                  const SizedBox(height: 8),
                  _reservationItem(context, 'T5', 'Table 5 - 2 Pax', 'Today, 20:30 • Tran Thi B', 'Confirmed', AdminDashboardStyles.primary),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AdminDashboardStyles.primary,
        unselectedItemColor: Theme.of(context).textTheme.bodyMedium?.color,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Tổng quan'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Thực đơn'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Đơn hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }

  Widget _summaryCard(BuildContext context, String title, String value, IconData icon, Color? accent) {
    final bool accentCard = accent != null;
    final cardColor = accentCard ? AdminDashboardStyles.primary.withOpacity(0.06) : Theme.of(context).cardColor;
    final textColor = accentCard
      ? AdminDashboardStyles.primary
      : (Theme.of(context).textTheme.headlineMedium?.color ?? Colors.black);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AdminDashboardStyles.cardRadius,
        border: Border.all(color: AdminDashboardStyles.primary.withOpacity(0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AdminDashboardStyles.smallMuted(context)),
              Icon(icon, color: accentCard ? AdminDashboardStyles.primary : Colors.grey.shade700),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: AdminDashboardStyles.largeNumber(context).copyWith(color: textColor)),
        ],
      ),
    );
  }

  Widget _iconAction(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AdminDashboardStyles.primary.withOpacity(0.10)),
          ),
          child: Icon(icon, color: AdminDashboardStyles.primary),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _reservationItem(BuildContext context, String short, String title, String subtitle, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AdminDashboardStyles.cardRadius,
        border: Border.all(color: AdminDashboardStyles.primary.withOpacity(0.10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AdminDashboardStyles.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(8.0)),
                alignment: Alignment.center,
                child: Text(short, style: TextStyle(color: AdminDashboardStyles.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AdminDashboardStyles.smallMuted(context)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildRevenueCard(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: AdminDashboardStyles.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(backgroundColor: Colors.green.shade50, child: Icon(Icons.attach_money, color: Colors.green)),
                  Chip(label: Row(children: [Icon(Icons.trending_up, size: 14), SizedBox(width: 4), Text('+15%')],), backgroundColor: Colors.green.shade50),
                ],
              ),
              const SizedBox(height: 8),
              Text('Total Revenue', style: AdminDashboardStyles.smallMuted(context)),
              const SizedBox(height: 6),
              Text('\$1,240.50', style: AdminDashboardStyles.largeNumber(context)),
              const SizedBox(height: 4),
              Text('vs. \$1,078 yesterday', style: AdminDashboardStyles.smallMuted(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallStat(BuildContext context, {required IconData icon, required String title, required String value, double progress = 0.5, Color? accent}) {
    accent ??= Colors.blue;
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: AdminDashboardStyles.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                CircleAvatar(backgroundColor: accent.withOpacity(0.12), child: Icon(icon, color: accent)),
                Icon(Icons.more_horiz)
              ]),
              const SizedBox(height: 8),
              Text(value, style: AdminDashboardStyles.largeNumber(context)),
              const SizedBox(height: 4),
              Text(title, style: AdminDashboardStyles.smallMuted(context)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, color: accent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction(String label, Color badgeColor, String imageUrl, IconData icon) {
    return InkWell(
      onTap: () {},
      child: ClipRRect(
        borderRadius: AdminDashboardStyles.cardRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black.withOpacity(0.7), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter))),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(backgroundColor: badgeColor, child: Icon(icon, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _alertTile(BuildContext context, IconData icon, String title, String subtitle, String time, Color color) {
    return Container(
      decoration: BoxDecoration(borderRadius: AdminDashboardStyles.cardRadius, color: Theme.of(context).cardColor, border: Border.all(color: Colors.grey.shade200)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: AdminDashboardStyles.smallMuted(context)),
        trailing: Text(time, style: AdminDashboardStyles.smallMuted(context)),
      ),
    );
  }
}
