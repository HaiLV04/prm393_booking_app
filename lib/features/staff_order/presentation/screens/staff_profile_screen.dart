import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/widgets/staff_widgets.dart';

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                                'NA',
                                style: StaffTypography.displayMedium(context.isDarkMode)
                                    .copyWith(color: StaffDesignSystem.primary),
                              ),
                            ),
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing16),
                          Text(
                            'Nguyễn Văn An',
                            style: StaffTypography.headlineSmall(context.isDarkMode),
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing4),
                          Text(
                            'an.nguyen@restaurant.com',
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
                              'NHÂN VIÊN',
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
                      _buildInfoCard('Họ và tên', 'Nguyễn Văn An'),
                      const SizedBox(height: StaffDesignSystem.spacing12),
                      _buildInfoCard('Email', 'an.nguyen@restaurant.com'),
                      const SizedBox(height: StaffDesignSystem.spacing12),
                      _buildInfoCard('Số điện thoại', '+84 912 345 678'),
                      const SizedBox(height: StaffDesignSystem.spacing12),
                      _buildInfoCard('Tên đăng nhập', 'an.nguyen'),
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
                            value: '24',
                            color: StaffDesignSystem.info,
                          ),
                          MetricCard(
                            icon: Icons.people_alt_outlined,
                            label: 'Khách',
                            value: '128',
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
                          onPressed: () {
                            // Logout action
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã đăng xuất')),
                            );
                          },
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
}
