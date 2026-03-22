import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:prm393_booking_app/core/network/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color _primary = Color(0xFF13EC5B);
  static const Color _lightBackground = Color(0xFFF6F8F6);
  static const Color _darkBackground = Color(0xFF102216);

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadMySettings();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadMySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse('${AppConfig.apiBaseUrl}/api/settings/me');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      final isSuccess = data['success'] == true || data['isSuccess'] == true;

      if (response.statusCode == 200 && isSuccess) {
        final payload = data['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
        _fullNameController.text = (payload['fullName'] ?? '').toString();
        _emailController.text = (payload['email'] ?? '').toString();
        _phoneController.text = (payload['phone'] ?? '').toString();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((data['message'] ?? 'Khong tai duoc thong tin').toString())),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loi ket noi server')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse('${AppConfig.apiBaseUrl}/api/settings/me');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          'phone': _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      final isSuccess = data['success'] == true || data['isSuccess'] == true;

      if (response.statusCode == 200 && isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text((data['message'] ?? 'Cap nhat thanh cong').toString())),
          );
          Navigator.pop(context, true);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((data['message'] ?? 'Cap nhat that bai').toString())),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loi ket noi server')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui long nhap ho ten';
    }
    if (value.trim().length < 2) {
      return 'Ho ten qua ngan';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(text)) {
      return 'Email khong hop le';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _darkBackground : _lightBackground;
    final cardColor = isDark ? const Color(0xFF1A2F20) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? const Color(0xFF9DB9A6) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          'Chinh sua thong tin',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thong tin ca nhan',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _fullNameController,
                                  label: 'Ho ten',
                                  hintText: 'Nhap ho ten',
                                  textColor: textColor,
                                  mutedColor: mutedColor,
                                  validator: _validateFullName,
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hintText: 'Nhap email',
                                  textColor: textColor,
                                  mutedColor: mutedColor,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _phoneController,
                                  label: 'So dien thoai',
                                  hintText: 'Nhap so dien thoai',
                                  textColor: textColor,
                                  mutedColor: mutedColor,
                                  keyboardType: TextInputType.phone,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveSettings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: const Color(0xFF102216),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(
                                      'Luu thay doi',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required Color textColor,
    required Color mutedColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: GoogleFonts.inter(color: mutedColor),
        hintStyle: GoogleFonts.inter(color: mutedColor.withValues(alpha: 0.8)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
