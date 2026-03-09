import 'package:flutter/material.dart';
import 'admin_dashboard_styles.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final bg = AdminDashboardStyles.background(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg.withOpacity(0.9),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Dashboard',
          style: AdminDashboardStyles.headerTitle(context),
        ),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg',
                        ),
                      ),
                      border: Border.all(
                        color: AdminDashboardStyles.primary.withOpacity(0.12),
                        width: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Admin',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PRM393 Restaurant Manager',
                        style: AdminDashboardStyles.smallMuted(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _summaryCard(
                    context,
                    'Tổng bàn',
                    '8',
                    Icons.table_restaurant,
                  ),
                  _summaryCard(context, 'Đang dùng', '3', Icons.groups),
                  _summaryCard(
                    context,
                    'Order hôm nay',
                    '12',
                    Icons.receipt_long,
                  ),
                  _summaryCard(context, 'Doanh thu', '5.2M', Icons.payments),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'Quick Actions',
                style: AdminDashboardStyles.headerTitle(context),
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _actionButton(context, Icons.bar_chart, 'Thống kê', () {}),
                  _actionButton(context, Icons.badge, 'Nhân viên', () {}),
                  _actionButton(context, Icons.map, 'Khu vực', () {}),
                  _actionButton(context, Icons.settings, 'Cài đặt', () {}),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Reservations',
                    style: AdminDashboardStyles.headerTitle(context),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: TextStyle(color: AdminDashboardStyles.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  _reservationItem(
                    context,
                    'T2',
                    'Table 2 - 4 Pax',
                    'Today, 19:00 • Nguyen Van A',
                    'Pending',
                    Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  _reservationItem(
                    context,
                    'T5',
                    'Table 5 - 2 Pax',
                    'Today, 20:30 • Tran Thi B',
                    'Confirmed',
                    AdminDashboardStyles.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final cardColor = AdminDashboardStyles.primary.withOpacity(0.06);
    final textColor = AdminDashboardStyles.primary;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AdminDashboardStyles.cardRadius,
        border: Border.all(
          color: AdminDashboardStyles.primary.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AdminDashboardStyles.smallMuted(context)),
              Icon(icon, color: AdminDashboardStyles.primary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AdminDashboardStyles.largeNumber(
              context,
            ).copyWith(color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback? onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AdminDashboardStyles.card(context),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AdminDashboardStyles.borderColor(context),
                  ),
                ),
                child: Icon(icon, color: AdminDashboardStyles.primary),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reservationItem(
    BuildContext context,
    String short,
    String title,
    String subtitle,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AdminDashboardStyles.card(context),
        borderRadius: AdminDashboardStyles.cardRadius,
        border: Border.all(color: AdminDashboardStyles.borderColor(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AdminDashboardStyles.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  short,
                  style: TextStyle(
                    color: AdminDashboardStyles.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AdminDashboardStyles.smallMuted(context),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
