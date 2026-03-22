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
  int _page = 1;
  static const int _pageSize = 10;
  int _totalCount = 0;
  bool? _activeFilter;

  @override
  void initState() {
    super.initState();
    _fetchStaffList();
  }

  Future<void> _fetchStaffList({int? page}) async {
    final targetPage = page ?? _page;
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final queryParams = <String, String>{
        'page': targetPage.toString(),
        'pageSize': _pageSize.toString(),
      };

      final keyword = _searchController.text.trim();
      if (keyword.isNotEmpty) {
        queryParams['keyword'] = keyword;
      }
      if (_activeFilter != null) {
        queryParams['isActive'] = _activeFilter!.toString();
      }

      final url = Uri.parse('${AppConfig.apiBaseUrl}/api/admin/staff').replace(
        queryParameters: queryParams,
      );

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
        final result = data['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
        final items = result['items'] as List<dynamic>? ?? [];
        if (mounted) {
          setState(() {
            _page = (result['page'] as int?) ?? targetPage;
            _totalCount = (result['totalCount'] as int?) ?? items.length;
            _staff = items
                .whereType<Map<String, dynamic>>()
                .map(_StaffItem.fromJson)
                .toList();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message']?.toString() ?? 'Failed to load staff list')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to server')),
        );
      }
    }
  }

  Future<void> _createStaff({
    required String fullName,
    required String username,
    required String password,
    String? email,
    String? phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/admin/staff');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fullName': fullName,
        'username': username,
        'password': password,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      }),
    );

    final data = jsonDecode(response.body);
    final isSuccess = data['success'] == true || data['isSuccess'] == true;
    if ((response.statusCode == 201 || response.statusCode == 200) && isSuccess) {
      await _fetchStaffList(page: 1);
      return;
    }

    throw Exception(data['message']?.toString() ?? 'Failed to create staff');
  }

  Future<_StaffItem> _getStaffById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/admin/staff/$id');
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
      final item = data['data'] as Map<String, dynamic>?;
      if (item != null) {
        return _StaffItem.fromJson(item);
      }
    }

    throw Exception(data['message']?.toString() ?? 'Failed to get staff detail');
  }

  Future<void> _updateStaff({
    required int id,
    required String fullName,
    String? email,
    String? phone,
    String? password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/admin/staff/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fullName': fullName,
        if (email != null && email.isNotEmpty) 'email': email else 'email': null,
        if (phone != null && phone.isNotEmpty) 'phone': phone else 'phone': null,
        if (password != null && password.isNotEmpty) 'password': password,
      }),
    );

    final data = jsonDecode(response.body);
    final isSuccess = data['success'] == true || data['isSuccess'] == true;
    if (response.statusCode == 200 && isSuccess) {
      await _fetchStaffList();
      return;
    }

    throw Exception(data['message']?.toString() ?? 'Failed to update staff');
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
      } else {
        setState(() {});
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

  Future<void> _showCreateStaffDialog() async {
    final fullNameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tao tai khoan nhan vien'),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 360,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(labelText: 'Ho ten'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhap ho ten' : null,
                    ),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhap username' : null,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Mat khau tam'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Nhap mat khau';
                        if (v.trim().length < 8) return 'Mat khau toi thieu 8 ky tu';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Huy'),
            ),
            FilledButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }

                try {
                  await _createStaff(
                    fullName: fullNameController.text.trim(),
                    username: usernameController.text.trim(),
                    password: passwordController.text.trim(),
                    email: emailController.text.trim(),
                    phone: phoneController.text.trim(),
                  );
                  if (!mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tao tai khoan thanh cong')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: const Text('Tao moi'),
            ),
          ],
        );
      },
    );

    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  Future<void> _showStaffDetailDialog(_StaffItem listItem) async {
    try {
      final detail = await _getStaffById(listItem.id);

      if (!mounted) {
        return;
      }

      final fullNameController = TextEditingController(text: detail.name);
      final emailController = TextEditingController(text: detail.email == 'N/A' ? '' : detail.email);
      final phoneController = TextEditingController(text: detail.phone ?? '');
      final passwordController = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Thong tin nhan vien'),
            content: Form(
              key: formKey,
              child: SizedBox(
                width: 360,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username: ${detail.username}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('Created: ${_formatDate(detail.createdAt)}'),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(labelText: 'Ho ten'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhap ho ten' : null,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: 'Phone'),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Mat khau moi (khong bat buoc)'),
                        validator: (v) {
                          if (v == null || v.isEmpty) return null;
                          if (v.trim().length < 6) return 'Mat khau toi thieu 6 ky tu';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Dong'),
              ),
              FilledButton(
                onPressed: () async {
                  if (!(formKey.currentState?.validate() ?? false)) {
                    return;
                  }

                  try {
                    await _updateStaff(
                      id: detail.id,
                      fullName: fullNameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    if (!mounted) return;
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cap nhat nhan vien thanh cong')),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: const Text('Luu'),
              ),
            ],
          );
        },
      );

      fullNameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      passwordController.dispose();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String _formatDate(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$d/$m/$y';
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

    final totalPages = _totalCount == 0 ? 1 : ((_totalCount + _pageSize - 1) ~/ _pageSize);

    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateStaffDialog,
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
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _fetchStaffList(page: 1),
                    decoration: InputDecoration(
                      hintText: 'Tim kiem nhan vien',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () => _fetchStaffList(page: 1),
                        icon: const Icon(Icons.arrow_forward),
                      ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Text('Trang thai:', style: GoogleFonts.inter(color: muted)),
                      const SizedBox(width: 8),
                      DropdownButton<bool?>(
                        value: _activeFilter,
                        items: const [
                          DropdownMenuItem<bool?>(value: null, child: Text('Tat ca')),
                          DropdownMenuItem<bool?>(value: true, child: Text('Dang hoat dong')),
                          DropdownMenuItem<bool?>(value: false, child: Text('Tam khoa')),
                        ],
                        onChanged: (value) {
                          setState(() => _activeFilter = value);
                          _fetchStaffList(page: 1);
                        },
                      ),
                      const Spacer(),
                      Text(
                        'Tong: $_totalCount',
                        style: GoogleFonts.inter(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: _primary))
                    : ListView.separated(
                        padding: const EdgeInsets.only(top: 6, bottom: 90),
                        itemCount: _staff.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                        itemBuilder: (context, index) {
                          final item = _staff[index];
                          return ListTile(
                            onTap: () => _showStaffDetailDialog(item),
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
                              item.subtitle,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _page > 1 ? () => _fetchStaffList(page: _page - 1) : null,
                          icon: const Icon(Icons.chevron_left),
                          label: const Text('Prev'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$_page / $totalPages',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _page < totalPages ? () => _fetchStaffList(page: _page + 1) : null,
                          icon: const Icon(Icons.chevron_right),
                          label: const Text('Next'),
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
}

class _StaffItem {
  _StaffItem({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.avatarUrl,
    required this.isActive,
    required this.isAdmin,
    required this.createdAt,
  });

  final int id;

  final String name;
  final String username;
  final String email;
  final String? phone;
  final String role;
  final String avatarUrl;
  bool isActive;
  final bool isAdmin;
  final DateTime createdAt;

  String get subtitle {
    final phonePart = (phone != null && phone!.isNotEmpty) ? ' • ${phone!}' : '';
    return '$email$phonePart';
  }

  factory _StaffItem.fromJson(Map<String, dynamic> json) {
    final fullName = (json['fullName'] ?? '').toString();
    return _StaffItem(
      id: (json['id'] as int?) ?? 0,
      name: fullName.isEmpty ? 'Unknown' : fullName,
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? 'N/A').toString(),
      phone: json['phone']?.toString(),
      role: (json['role'] ?? 'staff').toString().toUpperCase(),
      avatarUrl: 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(fullName.isEmpty ? 'Unknown' : fullName)}&background=random',
      isActive: (json['isActive'] as bool?) ?? false,
      isAdmin: (json['role'] ?? '').toString().toLowerCase() == 'admin',
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}
