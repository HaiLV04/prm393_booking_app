import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgLight = Color(0xFFF6F8F6);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _surfaceDark = Color(0xFF1C2E21);
  static const Color _inputDark = Color(0xFF28392E);

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://localhost:5200/api/auth/register');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': _fullNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'role': 'staff', // Send default role as in backend model
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['isSuccess'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Registration successful. Please login.')),
          );
          Navigator.pop(context); // Go back to login
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Registration failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to server (Ensure backend is running)')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? _bgDark : _bgLight;
    final cardColor = isDark ? _surfaceDark : Colors.white;
    final inputBg = isDark ? _inputDark : const Color(0xFFF8FAFC); // slate-50
    final textColor = isDark
        ? Colors.white
        : const Color(0xFF0F172A); // slate-900
    final labelColor = isDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF334155); // slate-300/700
    final hintColor = isDark
        ? const Color(0xFF9DB9A6)
        : const Color(0xFF94A3B8); // slate-400
    final borderColor = isDark
        ? Colors.transparent
        : const Color(0xFFCBD5E1); // slate-300
    final iconColor = isDark
        ? const Color(0xFF9DB9A6)
        : const Color(0xFF94A3B8); // slate-400

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // TopAppBar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back),
                        color: textColor,
                        style: IconButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 48.0),
                          child: Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.015,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        // Form Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              if (!isDark)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTextField(
                                  controller: _fullNameController,
                                  labelText: 'Full Name',
                                  hintText: 'Enter full name',
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  labelColor: labelColor,
                                  hintColor: hintColor,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _emailController,
                                  labelText: 'Email',
                                  hintText: 'Enter email',
                                  keyboardType: TextInputType.emailAddress,
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  labelColor: labelColor,
                                  hintColor: hintColor,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _phoneController,
                                  labelText: 'Phone Number',
                                  hintText: 'Enter phone number',
                                  keyboardType: TextInputType.phone,
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  labelColor: labelColor,
                                  hintColor: hintColor,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _usernameController,
                                  labelText: 'Username',
                                  hintText: 'Enter username',
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  labelColor: labelColor,
                                  hintColor: hintColor,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _passwordController,
                                  labelText: 'Password',
                                  hintText: 'Enter password',
                                  obscureText: _obscurePassword,
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  labelColor: labelColor,
                                  hintColor: hintColor,
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
                                      color: iconColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _confirmPasswordController,
                                  labelText: 'Confirm Password',
                                  hintText: 'Re-enter password',
                                  obscureText: _obscureConfirmPassword,
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  labelColor: labelColor,
                                  hintColor: hintColor,
                                  suffixWidget: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: iconColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Action Buttons
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primary,
                                  foregroundColor: const Color(0xFF0A1A10),
                                  elevation: 4,
                                  shadowColor: _primary.withValues(alpha: 0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF0A1A10),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Register',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF475569),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.maybePop(context),
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _primary,
                                      decoration: TextDecoration.underline,
                                      decorationColor: _primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required Color inputBg,
    required Color borderColor,
    required Color textColor,
    required Color labelColor,
    required Color hintColor,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            labelText,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: GoogleFonts.inter(fontSize: 16, color: textColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(color: hintColor),
            filled: true,
            fillColor: inputBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: suffixWidget,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: borderColor == Colors.transparent
                  ? BorderSide.none
                  : BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: borderColor == Colors.transparent
                  ? BorderSide.none
                  : BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _primary, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
