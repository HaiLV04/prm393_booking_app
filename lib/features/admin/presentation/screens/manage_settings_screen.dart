import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prm393_booking_app/core/network/api_client.dart';
import 'package:prm393_booking_app/features/admin/data/admin_facility_repository.dart';
import 'package:prm393_booking_app/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageSettingsScreen extends StatefulWidget {
  const ManageSettingsScreen({super.key});

  @override
  State<ManageSettingsScreen> createState() => _ManageSettingsScreenState();
}

class _ManageSettingsScreenState extends State<ManageSettingsScreen> {
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _primary => const Color(0xFF13EC5B);
  Color get _bg => _isDark ? const Color(0xFF0B2518) : const Color(0xFFF0F5F2);
  Color get _card => _isDark ? const Color(0xFF143523) : Colors.white;
  Color get _muted =>
      _isDark ? const Color(0xFFA0B9AA) : const Color(0xFF6B8074);
  Color get _textColor => _isDark ? Colors.white : const Color(0xFF0B2518);
  Color get _border =>
      _isDark ? const Color(0xFF1F4630) : const Color(0xFFE2EBE5);
  Color get _sheetBg => _isDark ? const Color(0xFF102C1D) : Colors.white;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _repository = AdminFacilityRepository();

  bool _loading = true;
  bool _saving = false;
  TimeOfDay _openTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closeTime = const TimeOfDay(hour: 22, minute: 0);
  String? _error;

  static const String _openHourKey = 'admin_open_hour';
  static const String _openMinuteKey = 'admin_open_minute';
  static const String _closeHourKey = 'admin_close_hour';
  static const String _closeMinuteKey = 'admin_close_minute';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final settings = await _repository.getMySettings();
      _fullNameController.text = settings.fullName;
      _phoneController.text = settings.phone ?? '';
      _emailController.text = settings.email ?? '';
    } on ApiException catch (e) {
      _error = 'Unable to load settings: ${e.message}';
    } catch (_) {
      _error = 'Unable to load settings';
    } finally {
      await _loadLocalPreferences();
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadLocalPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final openHour = prefs.getInt(_openHourKey) ?? _openTime.hour;
    final openMinute = prefs.getInt(_openMinuteKey) ?? _openTime.minute;
    final closeHour = prefs.getInt(_closeHourKey) ?? _closeTime.hour;
    final closeMinute = prefs.getInt(_closeMinuteKey) ?? _closeTime.minute;

    _openTime = TimeOfDay(hour: openHour, minute: openMinute);
    _closeTime = TimeOfDay(hour: closeHour, minute: closeMinute);
  }

  Future<void> _saveOperatingHours(TimeOfDay open, TimeOfDay close) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_openHourKey, open.hour);
    await prefs.setInt(_openMinuteKey, open.minute);
    await prefs.setInt(_closeHourKey, close.hour);
    await prefs.setInt(_closeMinuteKey, close.minute);
  }

  String _formatTime(TimeOfDay time) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _openOperatingHoursEditor() async {
    var draftOpen = _openTime;
    var draftClose = _closeTime;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (_, setDialogState) {
            return AlertDialog(
              title: const Text('Operating Hours'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Open time'),
                    subtitle: Text(_formatTime(draftOpen)),
                    trailing: const Icon(Icons.schedule),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: dialogContext,
                        initialTime: draftOpen,
                      );
                      if (picked != null) {
                        setDialogState(() => draftOpen = picked);
                      }
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Close time'),
                    subtitle: Text(_formatTime(draftClose)),
                    trailing: const Icon(Icons.schedule),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: dialogContext,
                        initialTime: draftClose,
                      );
                      if (picked != null) {
                        setDialogState(() => draftClose = picked);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved == true) {
      await _saveOperatingHours(draftOpen, draftClose);
      if (!mounted) return;
      setState(() {
        _openTime = draftOpen;
        _closeTime = draftClose;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      await _repository.updateMySettings(
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings updated successfully')),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: ${e.message}')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _openRestaurantDetailsEditor() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 14,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _input(
                  controller: _fullNameController,
                  label: 'Name',
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter name'
                      : null,
                ),
                const SizedBox(height: 10),
                _input(controller: _phoneController, label: 'Phone'),
                const SizedBox(height: 10),
                _input(
                  controller: _emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    return regex.hasMatch(value.trim())
                        ? null
                        : 'Invalid email';
                  },
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving
                        ? null
                        : () async {
                            await _save();
                            if (mounted) Navigator.of(context).pop();
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: const Color(0xFF0B2518),
                    ),
                    child: Text(_saving ? 'Saving...' : 'Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: GoogleFonts.manrope(color: _textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.manrope(color: _muted),
        filled: true,
        fillColor: _card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ThemeController.instance.themeMode.value == ThemeMode.dark;

    if (_loading) {
      return Scaffold(
        backgroundColor: _bg,
        body: Center(child: CircularProgressIndicator(color: _primary)),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(backgroundColor: _bg, foregroundColor: _textColor),
        body: Center(
          child: Text(_error!, style: GoogleFonts.manrope(color: _textColor)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Settings',
              style: GoogleFonts.manrope(
                color: _textColor,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            _tile(
              icon: Icons.dark_mode,
              title: 'App Theme',
              subtitle: darkMode ? 'Dark' : 'Light',
              onTap: () async {
                await ThemeController.instance.setMode(
                  darkMode ? ThemeMode.light : ThemeMode.dark,
                );
                if (mounted) setState(() {});
              },
            ),
            _divider(),
            _tile(
              icon: Icons.storefront,
              title: 'Restaurant Details',
              subtitle: 'Name, contact, profile',
              onTap: _openRestaurantDetailsEditor,
            ),
            _divider(),
            _tile(
              icon: Icons.schedule,
              title: 'Operating Hours',
              subtitle:
                  '${_formatTime(_openTime)} - ${_formatTime(_closeTime)}',
              onTap: _openOperatingHoursEditor,
            ),
            _divider(),
            _tile(
              icon: Icons.restaurant_menu,
              title: 'Menu Management',
              subtitle: 'Digital menu options',
              onTap: () => Navigator.pushNamed(context, '/admin/menu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: _muted),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      color: _textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(color: _muted, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: _muted),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(color: Color(0xFF1F4630), height: 1);
}
