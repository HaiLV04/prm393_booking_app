import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:prm393_booking_app/core/network/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgLight = Color(0xFFF6F8F6);
  static const Color _bgDark = Color(0xFF102216);

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    if (newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/change-password');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final isSuccess =
          data['success'] == true ||
          data['isSuccess'] == true ||
          data['Success'] == true;
      if (response.statusCode == 200 && isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (data['message'] ??
                        data['Message'] ??
                        'Failed to change password')
                    .toString(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot connect to ${AppConfig.apiBaseUrl}. Check backend host/port and device network.',
            ),
          ),
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
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final inputBg = isDark ? Colors.black.withValues(alpha: 0.2) : Colors.white;
    final borderColor = isDark
        ? _primary.withValues(alpha: 0.2)
        : _primary.withValues(alpha: 0.3);
    final helperColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          'Change Password',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _buildInputField(
                    label: 'Current Password',
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrentPassword,
                    inputBg: inputBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter current password';
                      }
                      return null;
                    },
                    onToggleVisibility: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    label: 'New Password',
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    inputBg: inputBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter new password';
                      }
                      if (value.trim().length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                    onToggleVisibility: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    label: 'Confirm New Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    inputBg: inputBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please confirm new password';
                      }
                      return null;
                    },
                    onToggleVisibility: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 14, color: helperColor),
                      const SizedBox(width: 4),
                      Text(
                        'Password must be at least 8 characters',
                        style: GoogleFonts.inter(fontSize: 12, color: helperColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: const Color(0xFF102216),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFF102216),
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save),
                                const SizedBox(width: 8),
                                Text(
                                  'Save Changes',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
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
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required Color inputBg,
    required Color borderColor,
    required Color textColor,
    required bool isDark,
    required String? Function(String?) validator,
    required VoidCallback onToggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? const Color(0xFFE2E8F0)
                    : const Color(0xFF1E293B),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    obscureText: obscureText,
                    validator: validator,
                    style: GoogleFonts.inter(fontSize: 16, color: textColor),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: GoogleFonts.inter(
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(15),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onToggleVisibility,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    child: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
