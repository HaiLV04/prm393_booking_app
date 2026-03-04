import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/common/presentation/screens/simple_placeholder_screen.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/screens/customer_home_screen.dart';
import 'package:prm393_booking_app/features/customer_menu/presentation/screens/customer_menu_screen.dart';
import 'package:prm393_booking_app/theme/app_theme.dart';
import 'package:prm393_booking_app/screen/login_screen.dart';

void main() {
  runApp(const GourmetHavenApp());
}

class GourmetHavenApp extends StatelessWidget {
  const GourmetHavenApp({super.key});

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgLight = Color(0xFFF6F8F6);
  static const Color _bgDark = Color(0xFF102216);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Table Management',
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
