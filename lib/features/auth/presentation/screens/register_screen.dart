import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgLight = Color(0xFFF6F8F6);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _surfaceDark = Color(0xFF1C3022);
  static const Color _borderDark = Color(0xFF2A4230);

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? _bgDark : _bgLight;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final inputBg = isDark ? _surfaceDark : Colors.white;
    final borderColor = isDark ? _borderDark : const Color(0xFFE2E8F0);
    final iconColor = isDark
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                _buildHeader(textColor),
                Expanded(
                  // SingleChildScrollView cho phép cuộn khi bàn phím hiện lên
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Create an Account',
                                style: GoogleFonts.manrope(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.42,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Join your team to manage tables efficiently.',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 12),
                                _buildLabel('Full Name', textColor),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _fullNameController,
                                  hintText: 'e.g. John Doe',
                                  suffixIcon: Icons.person_outline,
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  iconColor: iconColor,
                                  textColor: textColor,
                                  isDark: isDark,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                      ? 'Please enter your full name'
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                _buildLabel('Email Address', textColor),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _emailController,
                                  hintText: 'name@restaurant.com',
                                  suffixIcon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  iconColor: iconColor,
                                  textColor: textColor,
                                  isDark: isDark,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!v.contains('@')) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildLabel('Password', textColor),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _passwordController,
                                  hintText: 'Create a strong password',
                                  suffixIcon: _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  onSuffixTap: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  obscureText: _obscurePassword,
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  iconColor: iconColor,
                                  textColor: textColor,
                                  isDark: isDark,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    if (v.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28),
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _handleRegister,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primary,
                                      foregroundColor: const Color(0xFF102216),
                                      elevation: 4,
                                      shadowColor: _primary.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: const StadiumBorder(),
                                    ),
                                    child: Text(
                                      'Create Account',
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.24,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: subtitleColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.maybePop(context),
                                      child: Text(
                                        'Log In',
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: _primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back),
            color: textColor,
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
          ),
          Expanded(
            child: Text(
              'Register',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.27,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData suffixIcon,
    required Color inputBg,
    required Color borderColor,
    required Color iconColor,
    required Color textColor,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
    final suffixWidget = onSuffixTap != null
        ? IconButton(
            onPressed: onSuffixTap,
            icon: Icon(suffixIcon, color: iconColor, size: 20),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(suffixIcon, color: iconColor, size: 20),
          );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.manrope(fontSize: 16, color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.manrope(
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: suffixWidget,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  void _handleRegister() {
    // validate() chạy tất cả validator của các TextFormField trong Form
    // Nếu tất cả đều hợp lệ thì mới thực hiện logic đăng ký
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: implement registration logic (gọi API, lưu token, navigate...)
    }
  }
}
