import 'package:flutter/material.dart';

class EditReservationScreen extends StatefulWidget {
  const EditReservationScreen({super.key});

  @override
  State<EditReservationScreen> createState() =>
      _EditReservationScreenState();
}

class _EditReservationScreenState
    extends State<EditReservationScreen> {

  final Color primary = const Color(0xFF13EC5B);
  final Color backgroundDark = const Color(0xFF102216);
  final Color surfaceDark = const Color(0xFF1C271F);
  final Color borderDark = const Color(0xFF3B5443);

  final TextEditingController nameController =
      TextEditingController(text: "Alex Johnson");

  final TextEditingController partyController =
      TextEditingController(text: "4");

  final TextEditingController tableController =
      TextEditingController(text: "12");

  final TextEditingController noteController =
      TextEditingController(
          text:
              "Window seat preferred. One guest has a nut allergy.");

  DateTime selectedDate = DateTime(2023, 10, 24);
  TimeOfDay selectedTime = const TimeOfDay(hour: 19, minute: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Reservation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Save",
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            const Text(
              "Reservation Details",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Modify the booking information below.",
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 24),

            /// GUEST NAME
            _buildLabel("Guest Name"),
            const SizedBox(height: 8),
            _buildInputField(
              controller: nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            /// DATE + TIME
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Date"),
                      const SizedBox(height: 8),
                      _buildPickerField(
                        icon: Icons.calendar_today_outlined,
                        text:
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        onTap: () async {
                          final picked =
                              await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate:
                                DateTime(2020),
                            lastDate:
                                DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() =>
                                selectedDate = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Time"),
                      const SizedBox(height: 8),
                      _buildPickerField(
                        icon: Icons.schedule_outlined,
                        text:
                            selectedTime.format(context),
                        onTap: () async {
                          final picked =
                              await showTimePicker(
                            context: context,
                            initialTime:
                                selectedTime,
                          );
                          if (picked != null) {
                            setState(() =>
                                selectedTime = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// PARTY + TABLE
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Party Size"),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller:
                            partyController,
                        icon: Icons.groups_outlined,
                        keyboardType:
                            TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Table No."),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller:
                            tableController,
                        icon: Icons.table_bar_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// NOTES
            _buildLabel("Notes & Requests"),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: surfaceDark,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: borderDark),
                ),
                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: borderDark),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// STATUS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                    color:
                        primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        primary.withOpacity(0.2),
                    child: Icon(
                      Icons.verified,
                      color: primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Text(
                          "Status",
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold),
                        ),
                        Text(
                          "CONFIRMED",
                          style: TextStyle(
                            color: primary,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Text(
                    "Log",
                    style:
                        TextStyle(color: Colors.white54),
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// DANGER ZONE
            const Text(
              "DANGER ZONE",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(
                        vertical: 16),
                side: const BorderSide(
                    color: Colors.red),
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.cancel),
              label: const Text(
                "Cancel Reservation",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Cancelling this reservation will notify the guest immediately via email and SMS.",
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon:
            Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide:
              BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide:
              BorderSide(color: borderDark),
        ),
      ),
    );
  }

  Widget _buildPickerField({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding:
            const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: surfaceDark,
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(color: borderDark),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}