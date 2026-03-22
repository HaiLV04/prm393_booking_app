import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/widgets/staff_widgets.dart';

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  late Future<Map<String, dynamic>> _profileFuture;
  final ApiClient _apiClient = ApiClient();
  final StaffOrderRepository _repository = StaffOrderRepository();

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<Map<String, dynamic>> _loadProfile() async {
    try {
      // Get user profile from API
      final response = await _apiClient.get('/api/auth/me');
      final dynamic dataValue = response.containsKey('data') ? response['data'] : response['Data'];
      final data = dataValue is Map<String, dynamic> ? dataValue : <String, dynamic>{};
      
      // Get today's statistics
      final reservations = await _repository.getReservations();
      final today = DateTime.now();
      final todayReservations = reservations.where((r) {
        final created = r.createdAt;
        return created.year == today.year &&
            created.month == today.month &&
            created.day == today.day;
      }).toList();
      
      return {
        'fullName': data['fullName'] ?? data['FullName'] ?? 'N/A',
        'email': data['email'] ?? data['Email'] ?? 'N/A',
        'phone': data['phone'] ?? data['Phone'] ?? 'N/A',
        'username': data['username'] ?? data['Username'] ?? 'N/A',
        'role': data['role'] ?? data['Role'] ?? 'Nhân viên',
        'orders': todayReservations.length,
        'customers': todayReservations.fold<int>(
          0,
          (sum, r) => sum + (r.guestCount ?? 0),
        ),
      };
    } catch (e) {
      return {
        'fullName': 'Không tải được',
        'email': 'error@example.com',
        'phone': 'N/A',
        'username': 'N/A',
        'role': 'N/A',
        'orders': 0,
        'customers': 0,
        'error': e.toString(),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = snapshot.data ?? {};
        final fullName = profile['fullName'] as String? ?? 'N/A';
        final email = profile['email'] as String? ?? 'N/A';
        final phone = profile['phone'] as String? ?? 'N/A';
        final username = profile['username'] as String? ?? 'N/A';
        final role = profile['role'] as String? ?? 'Nhân viên';
        final orders = profile['orders'] as int? ?? 0;
        final customers = profile['customers'] as int? ?? 0;

        return Scaffold(
          backgroundColor: context.backgroundColor,
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    StaffAppHeader(
                      title: 'Tài khoản',
                      subtitle: 'Cá nhân',
                      showRefresh: false,
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          StaffDesignSystem.spacing16,
                          StaffDesignSystem.spacing16,
                          StaffDesignSystem.spacing16,
                          StaffDesignSystem.spacing16,
                        ),
                        children: [
                          // Profile header
                          Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: StaffDesignSystem.primary.withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: StaffDesignSystem.primary,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _getInitials(fullName),
                                    style: StaffTypography.displayMedium(context.isDarkMode)
                                        .copyWith(color: StaffDesignSystem.primary),
                                  ),
                                ),
                              ),
                              const SizedBox(height: StaffDesignSystem.spacing16),
                              Text(
                                fullName,
                                style: StaffTypography.headlineSmall(context.isDarkMode),
                              ),
                              const SizedBox(height: StaffDesignSystem.spacing4),
                              Text(
                                email,
                                style: StaffTypography.bodySmall(context.isDarkMode),
                              ),
                              const SizedBox(height: StaffDesignSystem.spacing12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: StaffDesignSystem.spacing16,
                                  vertical: StaffDesignSystem.spacing8,
                                ),
                                decoration: BoxDecoration(
                                  color: StaffDesignSystem.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
                                ),
                                child: Text(
                                  role.toUpperCase(),
                                  style: StaffTypography.labelMedium(context.isDarkMode)
                                      .copyWith(color: StaffDesignSystem.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing32),
                          
                          // Account information section
                          SectionHeader(title: 'Thông tin tài khoản'),
                          const SizedBox(height: StaffDesignSystem.spacing16),
                          _buildInfoCard('Họ và tên', fullName),
                          const SizedBox(height: StaffDesignSystem.spacing12),
                          _buildInfoCard('Email', email),
                          const SizedBox(height: StaffDesignSystem.spacing12),
                          _buildInfoCard('Số điện thoại', phone),
                          const SizedBox(height: StaffDesignSystem.spacing12),
                          _buildInfoCard('Tên đăng nhập', username),
                          const SizedBox(height: StaffDesignSystem.spacing24),
                          
                          // Statistics section
                          SectionHeader(title: 'Thống kê hôm nay'),
                          const SizedBox(height: StaffDesignSystem.spacing16),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: StaffDesignSystem.spacing12,
                            mainAxisSpacing: StaffDesignSystem.spacing12,
                            childAspectRatio: 1.2,
                            children: [
                              MetricCard(
                                icon: Icons.receipt_long_outlined,
                                label: 'Đơn hàng',
                                value: '$orders',
                                color: StaffDesignSystem.info,
                              ),
                              MetricCard(
                                icon: Icons.people_alt_outlined,
                                label: 'Khách',
                                value: '$customers',
                                color: StaffDesignSystem.success,
                              ),
                            ],
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing32),
                          
                          // Action buttons
                          SectionHeader(title: 'Tùy chọn'),
                          const SizedBox(height: StaffDesignSystem.spacing16),
                          _buildActionButton(
                            icon: Icons.lock_outline,
                            label: 'Đổi mật khẩu',
                            onTap: () => _showChangePasswordDialog(),
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing12),
                          _buildActionButton(
                            icon: Icons.language_outlined,
                            label: 'Ngôn ngữ',
                            trailing: 'Tiếng Việt',
                            onTap: () {},
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing12),
                          _buildActionButton(
                            icon: Icons.notifications_outlined,
                            label: 'Thông báo',
                            onTap: () {},
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing24),
                          
                          // Logout button
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: StaffDesignSystem.error,
                              ),
                              onPressed: () => _logout(),
                              child: const Text('Đăng xuất'),
                            ),
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordCtrl = TextEditingController();
    final newPasswordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(StaffDesignSystem.spacing24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Đổi mật khẩu',
                style: StaffTypography.headlineSmall(context.isDarkMode),
              ),
              const SizedBox(height: StaffDesignSystem.spacing24),
              TextField(
                controller: oldPasswordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Mật khẩu hiện tại',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
                  ),
                ),
              ),
              const SizedBox(height: StaffDesignSystem.spacing12),
              TextField(
                controller: newPasswordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Mật khẩu mới',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
                  ),
                ),
              ),
              const SizedBox(height: StaffDesignSystem.spacing12),
              TextField(
                controller: confirmPasswordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Xác nhận mật khẩu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
                  ),
                ),
              ),
              const SizedBox(height: StaffDesignSystem.spacing24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                  const SizedBox(width: StaffDesignSystem.spacing8),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã cập nhật mật khẩu')),
                      );
                    },
                    child: const Text('Cập nhật'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty || name == 'N/A') return 'NA';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return parts[0].isEmpty ? 'NA' : parts[0][0].toUpperCase();
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(StaffDesignSystem.spacing12),
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: StaffTypography.bodySmall(context.isDarkMode),
              ),
              const SizedBox(height: StaffDesignSystem.spacing4),
              Text(
                value,
                style: StaffTypography.bodyMedium(context.isDarkMode),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(StaffDesignSystem.spacing12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: StaffDesignSystem.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(StaffDesignSystem.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    color: StaffDesignSystem.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: StaffDesignSystem.spacing12),
                Expanded(
                  child: Text(
                    label,
                    style: StaffTypography.bodyMedium(context.isDarkMode),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: StaffDesignSystem.spacing12),
                  Text(
                    trailing,
                    style: StaffTypography.bodySmall(context.isDarkMode),
                  ),
                ],
                const SizedBox(width: StaffDesignSystem.spacing8),
                Icon(
                  Icons.chevron_right,
                  color: context.borderColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout - clear token, navigate to login
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
