import 'package:flutter/material.dart';

// Auth
import 'package:prm393_booking_app/features/auth/presentation/screens/login_screen.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/register_screen.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/reset_password.dart'
  as auth;

// Admin
import 'package:prm393_booking_app/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/table_list_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/add_edit_table_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/manage_areas_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/manage_staff_account_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/category_menu_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/statistics_screen.dart';

// Reservation
import 'package:prm393_booking_app/features/reservation/presentation/screens/reservation_list_screen.dart';
import 'package:prm393_booking_app/features/reservation/presentation/screens/create_reservation_screen.dart';

// Staff Order
import 'package:prm393_booking_app/features/staff_order/presentation/screens/staff_dashboard_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/table_management_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/staff_order_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/order_detail_status_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/screens/checkout_screen.dart';

// Staff Profile
import 'package:prm393_booking_app/features/staff_profile/presentation/screens/manage_profile_screen.dart';

// Common
import 'package:prm393_booking_app/features/common/presentation/screens/simple_placeholder_screen.dart';

// Theme
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
      title: 'Gourmet Haven - Staff & Admin',
      theme: AppTheme.light,
      initialRoute: '/login',
      routes: {
        // ============ AUTH ROUTES ============
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/change-password': (_) => const auth.ResetPasswordScreen(),

        // ============ STAFF ROUTES (Core workflow) ============
        // Home: Dashboard with table overview
        '/staff/home': (_) => const StaffDashboardScreen(),
        '/staff/dashboard': (_) => const StaffDashboardScreen(),

        // Table Management: List and select tables for check-in
        '/staff/tables': (_) => const TableManagementScreen(),

        // Reservation: List active reservations
        '/staff/reservations': (_) => const ReservationListScreen(),
        '/reservations': (_) => const ReservationListScreen(),

        // Create/Edit Reservation + Check-in
        '/staff/reservation/create': (_) => const CreateReservationScreen(),
        '/create_reservations': (_) => const CreateReservationScreen(),

        // Order: Staff takes orders (add menu items to current order)
        '/staff/order': (_) => const StaffOrderScreen(),

        // Order Detail: Track order status and item details
        '/staff/order-detail': (_) => const OrderDetailStatusScreen(),

        // Checkout: Payment and close order (invoice generation)
        '/staff/checkout': (_) => const CheckoutScreen(),

        // Staff Profile: Manage personal account, password, preferences
        '/staff/profile': (_) => const ManageProfileScreen(),

        // ============ ADMIN ROUTES (Management & monitoring) ============
        // Admin Dashboard: KPIs, revenue, busy status
        '/admin': (_) => const AdminHomeScreen(),
        '/admin/dashboard': (_) => const AdminHomeScreen(),

        // Table Management: Add, edit, delete tables (CRUD)
        '/admin/tables': (_) => const TableListScreen(areaName: 'All Tables'),
        '/admin/table/add': (_) => const AddEditTableScreen(),

        // Area Management: Add, edit, delete dining areas
        '/admin/areas': (_) => const ManageAreasScreen(),

        // Staff Account Management: Add, edit, toggle inactive staff accounts
        '/admin/staff': (_) => const ManageStaffAccountScreen(),

        // Menu & Category Management: Add, edit, delete menu items and categories
        '/admin/menu': (_) => const CategoryMenuScreen(),

        // Statistics: Revenue, best-selling items, occupancy rates
        '/admin/statistics': (_) => const StatisticsScreen(),

        // ============ COMMON/FALLBACK ROUTES ============
        // 404 Not Found
        '/not-found': (_) => const SimplePlaceholderScreen(
          title: 'Page Not Found',
          message: 'The requested page does not exist.',
        ),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const SimplePlaceholderScreen(
            title: 'Page Not Found',
            message: 'The requested page does not exist.',
          ),
        );
      },
    );
  }
}
