import 'package:flutter/material.dart';
import 'admin_dashboard_styles.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bg = brightness == Brightness.dark
        ? AdminDashboardStyles.backgroundDark
        : AdminDashboardStyles.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg.withOpacity(0.9),
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Panel', style: TextStyle(color: AdminDashboardStyles.primary, fontSize: 12, fontWeight: FontWeight.w700)),
            Text('Dashboard', style: AdminDashboardStyles.headerTitle(context)),
          ],
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        actions: [
          Stack(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
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
              // Date filter row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Overview for today', style: AdminDashboardStyles.smallMuted(context)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: AdminDashboardStyles.primary.withOpacity(0.12), elevation: 0, shape: StadiumBorder()),
                    onPressed: () {},
                    icon: Icon(Icons.expand_more, size: 16, color: AdminDashboardStyles.primary),
                    label: Text('Oct 24, 2023', style: TextStyle(color: AdminDashboardStyles.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Stats grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildRevenueCard(context),
                  _buildSmallStat(context, icon: Icons.table_restaurant, title: 'Active Tables', value: '0', progress: 0),
                  _buildSmallStat(context, icon: Icons.event_seat, title: 'Pending Requests', value: '0', progress: 0, accent: Colors.orange),
                ],
              ),

              const SizedBox(height: 16),
              Text('Quick Actions', style: AdminDashboardStyles.headerTitle(context)),
              const SizedBox(height: 8),

              // Quick actions grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 4/3,
                children: [
                  _quickAction('Manage\nTables', AdminDashboardStyles.primary, 'https://picsum.photos/400/300?1', Icons.edit),
                  _quickAction('View\nReservations', Colors.white24, 'https://picsum.photos/400/300?2', Icons.calendar_month),
                  _quickAction('Staff\nSchedule', Colors.white24, 'https://picsum.photos/400/300?3', Icons.group),
                  _quickAction('Edit\nMenu', Colors.white24, 'https://picsum.photos/400/300?4', Icons.restaurant_menu),
                ],
              ),

              const SizedBox(height: 16),
              Text('Recent Activities', style: AdminDashboardStyles.headerTitle(context)),
              const SizedBox(height: 8),

              // Recent activities list
              Column(
                children: [
                  _alertTile(context, Icons.priority_high, 'VIP Reservation Cancelled', 'Table 5 - John Doe', '2m ago', Colors.red),
                  const SizedBox(height: 8),
                  _alertTile(context, Icons.person_add, 'New Waitlist Request', 'Party of 4', '15m ago', Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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
