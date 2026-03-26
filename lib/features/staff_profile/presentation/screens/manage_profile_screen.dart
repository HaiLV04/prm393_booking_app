import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:prm393_booking_app/core/network/app_config.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/reset_password.dart';
import 'package:prm393_booking_app/features/staff_profile/presentation/screens/edit_profile_screen.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  static const Color _primary = StaffDesignSystem.primary;

  final int _selectedNavIndex = 3;
  bool _isLoading = true;
  String _fullName = '';
  String _email = '';
  String _role = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/me');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final isSuccess =
          data['success'] == true ||
          data['isSuccess'] == true ||
          data['Success'] == true;
      final payload = (data['data'] ?? data['Data']) as Map<String, dynamic>?;
      if (response.statusCode == 200 && isSuccess && payload != null) {
        if (mounted) {
          setState(() {
            _fullName = (payload['fullName'] ?? payload['FullName'] ?? 'N/A')
                .toString();
            _email = (payload['email'] ?? payload['Email'] ?? 'N/A').toString();
            _role = (payload['role'] ?? payload['Role'] ?? 'STAFF')
                .toString()
                .toUpperCase();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    if (updated == true) {
      setState(() => _isLoading = true);
      await _fetchProfile();
    }
  }

  Future<void> _openChangePassword() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'NA';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = context.backgroundColor;
    final cardColor = context.cardColor;
    final muted = context.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Tài khoản',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: _primary),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          children: [
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isDark
                                            ? const Color(0xFF1A2F20)
                                            : const Color(0xFFE8F8ED),
                                        border: Border.all(
                                          color: _primary,
                                          width: 4,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _getInitials(_fullName),
                                          style: GoogleFonts.inter(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w700,
                                            color: _primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: InkWell(
                                        onTap: _openEditProfile,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: _primary,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: bgColor,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Color(0xFF102216),
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _fullName.isEmpty ? 'N/A' : _fullName,
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _email.isEmpty ? 'N/A' : _email,
                                  style: GoogleFonts.inter(
                                    color: muted,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    _role,
                                    style: GoogleFonts.inter(
                                      color: _primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _menuCard(
                              context,
                              cardColor: cardColor,
                              onTap: _openEditProfile,
                              icon: Icons.edit,
                              iconColor: _primary,
                              title: 'Chinh sua thong tin',
                              subtitle: 'Cap nhat email, so dien thoai',
                            ),
                            const SizedBox(height: 10),
                            _menuCard(
                              context,
                              cardColor: cardColor,
                              onTap: _openChangePassword,
                              icon: Icons.key,
                              iconColor: _primary,
                              title: 'Đổi mật khẩu',
                              subtitle: 'Bảo mật tài khoản',
                            ),
                            const SizedBox(height: 10),
                            _menuCard(
                              context,
                              cardColor: cardColor.withValues(alpha: 0.6),
                              icon: Icons.settings,
                              iconColor: Colors.grey,
                              title: 'Cài đặt',
                              subtitle: 'Chỉ dành cho quản trị viên',
                              enabled: false,
                              trailing: const Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _handleLogout,
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.logout,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Đăng xuất',
                                        style: GoogleFonts.inter(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required Color cardColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF9DB9A6)
        : const Color(0xFF64748B);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
        boxShadow: StaffDesignSystem.shadowLight,
      ),
      child: ListTile(
        enabled: enabled,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(color: muted, fontSize: 12),
        ),
        trailing: trailing ?? Icon(Icons.chevron_right, color: muted),
        onTap: enabled ? (onTap ?? () {}) : null,
      ),
    );
  }
}
