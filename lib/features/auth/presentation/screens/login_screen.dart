import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/register_screen.dart';
import 'package:prm393_booking_app/features/auth/presentation/screens/reset_password.dart';
import 'package:prm393_booking_app/features/customer_home/presentation/screens/customer_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key dùng để gọi validate() cho toàn bộ Form bên dưới
  final _formKey = GlobalKey<FormState>();

  // Controller để đọc giá trị người dùng nhập vào từng ô
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // true = ẩn mật khẩu, false = hiện mật khẩu
  bool _obscurePassword = true;

  // Bảng màu dùng chung trong màn hình này
  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgLight = Color(0xFFF6F8F6);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _inputDark = Color(0xFF1C271F);

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị xóa khỏi cây widget,
    // tránh memory leak nếu không dispose controller
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
    final inputBg = isDark ? _inputDark : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final iconColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        // SafeArea: tránh UI bị che bởi notch, status bar, home indicator
        child: Center(
          child: ConstrainedBox(
            // Giới hạn chiều rộng tối đa 448px → đẹp trên tablet/web
            constraints: const BoxConstraints(maxWidth: 448),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomerHomeScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_back),
                          color: textColor,
                          style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.27,
                              color: textColor,
                            ),
                          ),
                        ),
                        // SizedBox rỗng cân bằng layout để tiêu đề căn giữa đều
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    // SingleChildScrollView cho phép cuộn khi bàn phím hiện lên
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              // Icon nhà hàng nằm trong vòng tròn nền xanh mờ
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: _primary.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: _primary,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Welcome',
                                style: GoogleFonts.manrope(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.48,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Manage your restaurant tables efficiently.',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Form bọc các TextFormField để validate tập trung qua _formKey
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildLabel('Email', textColor),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _emailController,
                                  hintText: 'Enter your email',
                                  prefixIcon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  iconColor: iconColor,
                                  textColor: textColor,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildLabel('Password', textColor),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _passwordController,
                                  hintText: 'Enter your password',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: _obscurePassword,
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  iconColor: iconColor,
                                  textColor: textColor,
                                  isDark: isDark,
                                  // Nút mắt: bấm để toggle ẩn/hiện mật khẩu
                                  suffixWidget: IconButton(
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons
                                                .visibility_off_outlined // Đang ẩn
                                          : Icons
                                                .visibility_outlined, // Đang hiện
                                      color: iconColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ResetPasswordScreen(),
                                        ),
                                      ),
                                      child: Text(
                                        'Forgot Password?',
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: _primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                // Nút đăng nhập hình viên thuốc (StadiumBorder)
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed:
                                        _handleLogin, // Gọi hàm validate & login
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primary,
                                      foregroundColor: const Color(0xFF111813),
                                      elevation: 4,
                                      shadowColor: _primary.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape:
                                          const StadiumBorder(), // Bo tròn hai đầu
                                    ),
                                    child: Text(
                                      'Login',
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
                                      "Don't have an account? ",
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: subtitleColor,
                                      ),
                                    ),
                                    // Chuyển sang màn RegisterScreen khi bấm
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterScreen(),
                                        ),
                                      ),
                                      child: Text(
                                        'Register',
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: _primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Test Admin Panel Button
                                Center(
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushReplacementNamed(
                                      context,
                                      '/admin',
                                    ),
                                    child: Text(
                                      'Test Admin Panel',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: _primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
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

  // Widget tái sử dụng để hiển thị nhãn (label) phía trên mỗi ô nhập liệu
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

  // Widget tái sử dụng để tạo ô nhập liệu có style thống nhất
  // Nhận vào controller, icon, màu sắc và các tuỳ chọn như ẩn mật khẩu
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required Color inputBg,
    required Color borderColor,
    required Color iconColor,
    required Color textColor,
    required bool isDark,
    TextInputType keyboardType =
        TextInputType.text, // Mặc định bàn phím chữ thường
    bool obscureText = false, // Ẩn text (dùng cho password)
    Widget? suffixWidget, // Icon cuối ô (VD: mắt toggle)
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.manrope(fontSize: 16, color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.manrope(
          color: isDark ? const Color(0xFF9DB9A6) : const Color(0xFF94A3B8),
        ),
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefixIcon: Icon(prefixIcon, color: iconColor, size: 22),
        suffixIcon: suffixWidget,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
      ),
    );
  }

  // Xử lý sự kiện bấm nút Login
  void _handleLogin() {
    // validate() sẽ chạy tất cả validator của các TextFormField trong Form
    // Nếu tất cả đều hợp lệ thì mới thực hiện logic đăng nhập
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: implement login logic (gọi API, lưu token, navigate...)
    }
  }
}
