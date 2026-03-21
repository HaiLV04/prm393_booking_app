import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/add_edit_table_screen.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/login_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/order_detail_status_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/staff_dashboard_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/staff_order_screen.dart';
import 'package:prm393_booking_app/features/reservation/presentation/screens/create_reservation_screen.dart';
import 'package:prm393_booking_app/features/reservation/presentation/screens/reservation_list_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/table_management_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/order_management_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/staff_profile_screen.dart';
import 'package:prm393_booking_app/theme/app_theme.dart';

void main() {
  runApp(const GourmetHavenApp());
}

class GourmetHavenApp extends StatelessWidget {
  const GourmetHavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gourmet Haven',
      theme: AppTheme.light,
      initialRoute: '/reservations',
      routes: {
        // '/login': (_) => const LoginScreen(),
        // '/home': (_) => const CustomerHomeScreen(),
        // '/menu': (_) => const CustomerMenuScreen(),
        // '/book': (_) => const CustomerBookingScreen(),
        // '/my-bookings': (_) => const MyBookingsScreen(),
        // '/cart': (_) => const CustomerCartScreen(),
        // '/profile': (_) => const CustomerProfileScreen(),

        //reservation
        '/reservations': (_) => const ReservationListScreen(),
        '/create_reservations': (_) => const CreateReservationScreen(),
        '/login': (_) => const LoginScreen(),
        '/admin': (_) => const AdminHomeScreen(),
        '/admin/add-table': (_) => const AddEditTableScreen(),
        '/staff/dashboard': (_) => const StaffDashboardScreen(),
        '/staff/tables': (_) => const TableManagementScreen(),
        '/staff/orders': (_) => const OrderManagementScreen(),
        '/staff/profile': (_) => const StaffProfileScreen(),
        '/staff/order': (_) => const StaffOrderScreen(),
        '/staff/order-detail': (_) => const OrderDetailStatusScreen(),
      },
    );
  }
}
