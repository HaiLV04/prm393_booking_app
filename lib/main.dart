import 'package:flutter/material.dart';
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
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: _bgLight,
        colorScheme: const ColorScheme.light(
          primary: _primary,
          surface: _bgLight,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _bgDark,
        colorScheme: const ColorScheme.dark(
          primary: _primary,
          surface: _bgDark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const LoginScreen(),
    );
  }
}
