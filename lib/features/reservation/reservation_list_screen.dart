import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';


class ReservationListScreen extends StatelessWidget {
  const ReservationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102216),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102216),
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
        title: const Text(
          "Reservations",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search),
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: Color(0xFF13EC5B),
              labelColor: Color(0xFF13EC5B),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Upcoming"),
                Tab(text: "Past"),
                Tab(text: "Cancelled"),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  DateHeader(title: "Today, Oct 24"),
                  ReservationItem(
                    time: "19:00",
                    name: "John Doe",
                    pax: "4 pax",
                    table: "Table 4",
                    status: "Confirmed",
                    statusColor: Color(0xFF13EC5B),
                    subtitle: "+1 (555) 123-4567",
                  ),
                  ReservationItem(
                    time: "20:30",
                    name: "Alice Smith",
                    pax: "2 pax",
                    table: "Table 2",
                    status: "Pending",
                    statusColor: Colors.orange,
                    subtitle: "Note: Anniversary",
                  ),
                  DateHeader(title: "Tomorrow, Oct 25"),
                  ReservationItem(
                    time: "18:00",
                    name: "Bob Johnson",
                    pax: "5 pax",
                    table: "Table 6",
                    status: "Confirmed",
                    statusColor: Color(0xFF13EC5B),
                    subtitle: "VIP Guest",
                  ),
                  ReservationItem(
                    time: "19:30",
                    name: "Emily Davis",
                    pax: "3 pax",
                    table: "Table 1",
                    status: "Confirmed",
                    statusColor: Color(0xFF13EC5B),
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF13EC5B),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C2E21),
        selectedItemColor: const Color(0xFF13EC5B),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_restaurant),
            label: "Tables",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Reservations",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class DateHeader extends StatelessWidget {
  final String title;
  const DateHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(color: Colors.grey),
          )
        ],
      ),
    );
  }
}

class ReservationItem extends StatelessWidget {
  final String time;
  final String name;
  final String pax;
  final String table;
  final String status;
  final Color statusColor;
  final String? subtitle;

  const ReservationItem({
    super.key,
    required this.time,
    required this.name,
    required this.pax,
    required this.table,
    required this.status,
    required this.statusColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 2,
                  height: 80,
                  color: Colors.grey.shade700,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2E21),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.group, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(pax,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Icon(Icons.table_restaurant,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(table,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12),
                    )
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
