import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/login_screen.dart';
import 'package:prm393_booking_app/features/customer_booking/presentation/screens/customer_booking_screen.dart';
import 'package:prm393_booking_app/features/customer_cart/presentation/screens/customer_cart_screen.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/screens/customer_home_screen.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/screens/customer_menu_screen.dart';
import 'package:prm393_booking_app/features/customer_profile/presentation/screens/customer_profile_screen.dart';
import 'package:prm393_booking_app/theme/app_theme.dart';
import 'package:prm393_booking_app/features/admin_dashboard/admin_dashboard.dart';

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
      initialRoute: '/admin',
      routes: {
        '/admin': (_) => const AdminDashboardScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const CustomerHomeScreen(),
        '/menu': (_) => const CustomerMenuScreen(),
        '/book': (_) => const CustomerBookingScreen(),
        '/my-bookings': (_) => const MyBookingsScreen(),
        '/cart': (_) => const CustomerCartScreen(),
        '/profile': (_) => const CustomerProfileScreen(),
      },
    );
  }
}
