import 'package:flutter/material.dart';

class ReservationDetailScreen extends StatelessWidget {
  const ReservationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102216),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102216),
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
        centerTitle: true,
        title: const Text(
          "Reservation #8291",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Color(0xFF13EC5B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // ================= PROFILE =================
                  _buildProfileSection(),

                  const SizedBox(height: 24),

                  // ================= INFO CARDS =================
                  _buildInfoCards(),

                  const SizedBox(height: 24),

                  // ================= STATUS SECTION =================
                  _buildStatusSection(),

                  const SizedBox(height: 24),

                  // ================= NOTES =================
                  _buildNotesSection(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ================= BOTTOM ACTION BAR =================
          _buildBottomBar()
        ],
      ),
    );
  }

  // ==========================================================
  // PROFILE
  // ==========================================================

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 56,
              backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/300"),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF13EC5B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star,
                    size: 18, color: Colors.black),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "John Doe",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            Text(
              "VIP Member",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _actionChip(Icons.call, "Call"),
            const SizedBox(width: 8),
            _actionChip(Icons.mail, "Email"),
            const SizedBox(width: 8),
            _actionChip(Icons.chat, "Message"),
          ],
        )
      ],
    );
  }

  Widget _actionChip(IconData icon, String label) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E21),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF13EC5B)),
          const SizedBox(width: 6),
          Text(label)
        ],
      ),
    );
  }

  // ==========================================================
  // INFO CARDS
  // ==========================================================

  Widget _buildInfoCards() {
    return Row(
      children: const [
        Expanded(
            child: InfoCard(
          icon: Icons.groups,
          title: "Guests",
          value: "4",
        )),
        SizedBox(width: 12),
        Expanded(
            child: InfoCard(
          icon: Icons.calendar_today,
          title: "Date",
          value: "Oct 24",
        )),
        SizedBox(width: 12),
        Expanded(
            child: InfoCard(
          icon: Icons.schedule,
          title: "Time",
          value: "19:00",
        )),
      ],
    );
  }

  // ==========================================================
  // STATUS SECTION
  // ==========================================================

  Widget _buildStatusSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF15281C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _statusRow(
            icon: Icons.check_circle,
            title: "Current Status",
            value: "Confirmed",
            trailing: TextButton(
              onPressed: () {},
              child: const Text(
                "Change",
                style: TextStyle(
                    color: Color(0xFF13EC5B),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _divider(),
          _statusRow(
            icon: Icons.table_restaurant,
            title: "Table",
            value: "Table 12 (Main Hall)",
            trailing:
                const Icon(Icons.chevron_right, color: Colors.grey),
          ),
          _divider(),
          _statusRow(
            icon: Icons.person,
            title: "Server",
            value: "Sarah Jenkins",
            trailing: const CircleAvatar(
              radius: 14,
              backgroundImage:
                  NetworkImage("https://i.pravatar.cc/200"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow({
    required IconData icon,
    required String title,
    required String value,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF13EC5B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF13EC5B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          trailing
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      color: Colors.white12,
    );
  }

  // ==========================================================
  // NOTES
  // ==========================================================

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Notes & Requests",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF15281C),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "Customer is celebrating an anniversary. "
                "Requested a quiet corner table away from the kitchen. "
                "Allergic to shellfish.",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text("Anniversary"),
                    backgroundColor: Colors.amber,
                  ),
                  Chip(
                    label: Text("Allergy: Shellfish"),
                    backgroundColor: Colors.red,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  // ==========================================================
  // BOTTOM BAR
  // ==========================================================

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF102216),
        border: Border(
          top: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding:
                    const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {},
              child: const Text(
                "Cancel Booking",
                style:
                    TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13EC5B),
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {},
              child: const Text(
                "Check In Guest",
                style:
                    TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// INFO CARD WIDGET
// ==========================================================

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2E21),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF13EC5B)),
          const SizedBox(height: 6),
          Text(title,
              style:
                  const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}