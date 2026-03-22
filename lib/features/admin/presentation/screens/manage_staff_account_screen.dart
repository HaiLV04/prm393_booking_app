import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:prm393_booking_app/core/network/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageStaffAccountScreen extends StatefulWidget {
  const ManageStaffAccountScreen({super.key});

  @override
  State<ManageStaffAccountScreen> createState() => _ManageStaffAccountScreenState();
}

class _ManageStaffAccountScreenState extends State<ManageStaffAccountScreen> {
  static const Color _primary = Color(0xFF13EC5B);
  static const Color _lightBackground = Color(0xFFF6F8F6);
  static const Color _darkBackground = Color(0xFF102216);

  final TextEditingController _searchController = TextEditingController();

  List<_StaffItem> _staff = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStaffList();
  }

  Future<void> _fetchStaffList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse('${AppConfig.apiBaseUrl}/api/admin/staff');
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
        final items = data['data']['items'] as List<dynamic>? ?? [];
        if (mounted) {
          setState(() {
            _staff = items.map((e) => _StaffItem(
              id: e['id'],
              name: e['fullName'] ?? 'Unknown',
              email: e['email'] ?? 'N/A',
              role: e['role']?.toString().toUpperCase() ?? 'STAFF',
              avatarUrl: 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(e['fullName'] ?? 'Unknown')}&background=random',
              isActive: e['isActive'] ?? false,
              isAdmin: e['role']?.toString().toLowerCase() == 'admin',
            )).toList();
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

  Future<void> _toggleStaffActive(_StaffItem item, bool newValue) async {
    final oldState = item.isActive;
    setState(() => item.isActive = newValue);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse('${AppConfig.apiBaseUrl}/api/admin/staff/${item.id}/active');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'isActive': newValue,
        }),
      );

      final data = jsonDecode(response.body);
      final isSuccess = data['success'] == true || data['isSuccess'] == true;
      if (response.statusCode != 200 || !isSuccess) {
        setState(() => item.isActive = oldState);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Failed to update status')),
          );
        }
      }
    } catch (e) {
      setState(() => item.isActive = oldState);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to server')),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _darkBackground : _lightBackground;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final muted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final query = _searchController.text.trim().toLowerCase();
    final staffFiltered = _staff.where((s) {
      if (query.isEmpty) return true;
      return s.name.toLowerCase().contains(query) ||
          s.email.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _primary,
        foregroundColor: const Color(0xFF102216),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Nhan vien',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Tim kiem nhan vien',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: _primary))
                    : ListView.separated(
                        padding: const EdgeInsets.only(top: 6, bottom: 90),
                        itemCount: staffFiltered.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                        itemBuilder: (context, index) {
                          final item = staffFiltered[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(item.avatarUrl),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      color: item.isActive ? textColor : muted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: item.isAdmin
                                        ? _primary.withValues(alpha: 0.2)
                                        : (isDark
                                              ? Colors.white.withValues(alpha: 0.1)
                                              : Colors.black.withValues(alpha: 0.06)),
                                  ),
                                  child: Text(
                                    item.role,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: item.isAdmin ? _primary : muted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              item.email,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(color: muted, fontSize: 12),
                            ),
                            trailing: Switch(
                              value: item.isActive,
                              activeColor: _primary,
                              onChanged: (value) {
                                _toggleStaffActive(item, value);
                              },
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StaffItem {
  _StaffItem({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.isActive,
    required this.isAdmin,
  });

  final int id;

  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  bool isActive;
  final bool isAdmin;
}
