import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/register_screen.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/reset_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgLight = Color(0xFFF6F8F6);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _cardDark = Color(0xFF1C2E21);
  static const Color _inputBgDark = Color(0xFF28392E);
  static const Color _textMuted = Color(0xFF9DB9A6);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: implement login logic
      Navigator.pushReplacementNamed(context, '/staff/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? _bgDark : _bgLight;
    final cardColor = isDark ? _cardDark : Colors.white;
    final inputBg = isDark ? _inputBgDark : Colors.grey.shade200;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderColor = isDark
        ? _primary.withValues(alpha: 0.1)
        : Colors.black12;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo Area
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Center(
                      child: Icon(Icons.restaurant, color: _primary, size: 48),
                    ),
                  ),
                  Text(
                    'Restaurant Manager',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            'Login',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Username Input
                          _buildTextField(
                            controller: _usernameController,
                            hintText: 'Username',
                            prefixIcon: Icons.person,
                            inputBg: inputBg,
                            isDark: isDark,
                            textColor: textColor,
                          ),
                          const SizedBox(height: 16),

                          // Password Input
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock,
                            obscureText: _obscurePassword,
                            inputBg: inputBg,
                            isDark: isDark,
                            textColor: textColor,
                            suffixWidget: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: _textMuted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ResetPasswordScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: _primary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: _bgDark,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.inter(color: _textMuted),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Register',
                          style: GoogleFonts.inter(
                            color: _primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required Color inputBg,
    required bool isDark,
    required Color textColor,
    bool obscureText = false,
    Widget? suffixWidget,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.inter(fontSize: 16, color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: _textMuted),
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        prefixIcon: Icon(prefixIcon, color: _textMuted),
        suffixIcon: suffixWidget,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primary, width: 1),
        ),
      ),
    );
  }
}
