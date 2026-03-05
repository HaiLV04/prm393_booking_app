import 'package:flutter/material.dart';

class CreateReservationScreen extends StatefulWidget {
  const CreateReservationScreen({super.key});

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState
    extends State<CreateReservationScreen> {
  final Color primary = const Color(0xFF13EC5B);
  final Color backgroundDark = const Color(0xFF102216);
  final Color surfaceDark = const Color(0xFF1C2E21);
  final Color borderDark = const Color(0xFF2A4232);

  int guestCount = 4;
  int selectedTable = 0;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Create Reservation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Save",
              style: TextStyle(
                  color: primary, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle(Icons.person, "Customer Details"),
                const SizedBox(height: 15),
                customTextField("Full Name"),
                const SizedBox(height: 15),
                customTextField("Phone Number"),
                const SizedBox(height: 30),
                sectionTitle(Icons.calendar_month, "Reservation Details"),
                const SizedBox(height: 15),

                /// Date & Time
                Row(
                  children: [
                    Expanded(
                      child: dateTimeField(
                          "Date",
                          selectedDate == null
                              ? "Select Date"
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          pickDate),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: dateTimeField(
                          "Time",
                          selectedTime == null
                              ? "Select Time"
                              : selectedTime!.format(context),
                          pickTime),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// Guest Counter
                const Text(
                  "Number of Guests",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderDark),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      counterButton(Icons.remove, () {
                        if (guestCount > 1) {
                          setState(() => guestCount--);
                        }
                      }),
                      Text(
                        "$guestCount",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      counterButton(Icons.add, () {
                        setState(() => guestCount++);
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// Table Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Table",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "VIEW MAP",
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    )
                  ],
                ),

                const SizedBox(height: 15),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2),
                  itemBuilder: (context, index) {
                    return tableCard(index);
                  },
                ),

                const SizedBox(height: 30),

                const Text(
                  "Special Requests (Optional)",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                customTextField("Allergies, high chair needed...",
                    maxLines: 4),
              ],
            ),
          ),

          /// Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: backgroundDark,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {},
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget sectionTitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget customTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: surfaceDark,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary),
        ),
      ),
    );
  }

  Widget dateTimeField(
      String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderDark),
            ),
            child: Text(value),
          ),
        ),
      ],
    );
  }

  Widget counterButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onTap,
      ),
    );
  }

  Widget tableCard(int index) {
    bool selected = selectedTable == index;
    bool occupied = index == 3;

    return GestureDetector(
      onTap: occupied
          ? null
          : () {
              setState(() => selectedTable = index);
            },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: occupied
              ? Colors.grey.shade800
              : selected
                  ? primary.withOpacity(0.2)
                  : surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? primary : borderDark, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              occupied ? "OCCUPIED" : "AVAILABLE",
              style: TextStyle(
                  fontSize: 10,
                  color:
                      occupied ? Colors.red : primary,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              "Table 0${index + 1}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              "Main Hall • 4 Seats",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}