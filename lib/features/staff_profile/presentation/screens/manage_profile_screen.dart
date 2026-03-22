import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:prm393_booking_app/core/network/app_config.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/reset_password.dart';
import 'package:prm393_booking_app/features/staff_profile/presentation/screens/edit_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/login_screen.dart';

class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  static const Color _primary = Color(0xFF13EC5B);
  static const Color _lightBackground = Color(0xFFF6F8F6);
  static const Color _darkBackground = Color(0xFF102216);

  int _selectedNavIndex = 3;
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

      final data = jsonDecode(response.body);
      final isSuccess = data['success'] == true || data['isSuccess'] == true;
      if (response.statusCode == 200 && isSuccess) {
        if (mounted) {
          setState(() {
            _fullName = data['data']['fullName'] ?? 'N/A';
            _email = data['data']['email'] ?? 'N/A';
            _role = data['data']['role']?.toString().toUpperCase() ?? 'STAFF';
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
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
    final bgColor = isDark ? _darkBackground : _lightBackground;
    final cardColor = isDark ? const Color(0xFF1A2F20) : Colors.white;
    final muted = isDark ? const Color(0xFF9DB9A6) : const Color(0xFF64748B);

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
                    'Tai khoan',
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
                                        border: Border.all(color: _primary, width: 4),
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
                                            border: Border.all(color: bgColor, width: 2),
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
                              title: 'Doi mat khau',
                              subtitle: 'Bao mat tai khoan',
                            ),
                            const SizedBox(height: 10),
                            _menuCard(
                              context,
                              cardColor: cardColor,
                              icon: Icons.notifications,
                              iconColor: _primary,
                              title: 'Thong bao',
                              subtitle: 'Cap nhat he thong',
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '3',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.chevron_right, color: muted),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            _menuCard(
                              context,
                              cardColor: cardColor.withValues(alpha: 0.6),
                              icon: Icons.settings,
                              iconColor: Colors.grey,
                              title: 'Cai dat',
                              subtitle: 'Chi danh cho quan tri vien',
                              enabled: false,
                              trailing: const Icon(Icons.lock, color: Colors.grey),
                            ),
                            const SizedBox(height: 18),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _handleLogout,
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.logout, color: Colors.red),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Dang xuat',
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1F2F24)
                  : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _selectedNavIndex,
            onTap: _handleBottomNavTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: _primary,
            unselectedItemColor: muted,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Bang dieu khien',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.table_chart_outlined),
                activeIcon: Icon(Icons.table_chart),
                label: 'Ban',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'Don hang',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Tai khoan',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() => _selectedNavIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/staff/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/staff/tables');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/staff/orders');
        break;
      case 3:
        break;
    }
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
        borderRadius: BorderRadius.circular(12),
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
