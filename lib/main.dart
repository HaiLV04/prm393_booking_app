import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/common/presentation/screens/simple_placeholder_screen.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/screens/customer_home_screen.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/screens/customer_menu_screen.dart';
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
      initialRoute: '/home',
      routes: {
        '/home': (_) => const CustomerHomeScreen(),
        '/menu': (_) => const CustomerMenuScreen(),
        '/book': (_) => const SimplePlaceholderScreen(
          title: 'Bookings',
          message: 'Booking screen is under development.',
        ),
        '/cart': (_) => const SimplePlaceholderScreen(
          title: 'Cart',
          message: 'Cart screen is under development.',
        ),
        '/profile': (_) => const SimplePlaceholderScreen(
          title: 'Profile',
          message: 'Profile screen is under development.',
        ),
      },
    );
  }
}
