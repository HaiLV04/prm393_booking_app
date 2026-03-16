import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final List<_StaffItem> _staff = [
    _StaffItem(
      name: 'Nguyen Van A',
      email: 'nguyenvana@email.com',
      role: 'Admin',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDPH8RJv14WDN32sVTWoZo3jtbEyxzxa8KB37I4z2FTz4Cd7zeFiq_czsA66hhoXFKA67svPQzIqDPyfEMc_UUAnG4tLylkBZ_amKqr8kIhfDlU0jLgbb2MifytE1fYxMEZNpOya2bsQoDvN0l3XsNTIdJLa6dz3yI_MYVEqfzh7Ai2jciO8wtklK3_5psMHvLcrscLxUxFezrWO6TFXxiBEPNlBCWyLGcfLIHtxI8YziGl3TOsHNS45MvcY82YWtZ-Omsvpnony4I',
      isActive: true,
      isAdmin: true,
    ),
    _StaffItem(
      name: 'Tran Thi B',
      email: 'tranthib@email.com',
      role: 'Staff',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDYMZthLIIDxDu4wuwsC0DigfM9v2R-0g_TuJajtm-dVTqNGADzuLMg7GbmEnJHlX8-1U3wY2Q-he9_8Hzp-p8oYwXBUilDCenga_wxpLWlRbaIu8xr6kDNQDWP3JxfJuhzGYWdJ5HD77CikjMxwVzMcvjefGDODZkt2Ss33qJnBUADNiJWcZy3Uc3RgnoRwVSSMrza2It1pzl3tmeoa8nF-MX8f4CMGpFi0lF5jfB0CasoUbldx7eAQMn3ahkOWIhf2FtbiTNtwO8',
      isActive: true,
      isAdmin: false,
    ),
    _StaffItem(
      name: 'Le Van C',
      email: 'levanc@email.com',
      role: 'Staff',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAjkpzt_KmHwo35F8QnOu9xJmFKN2rA63pSmXA8Ehk3IGE5s8eodJvOmCbp1Fd1jy1004hNHtQwHUkAcBruJPqDlYYe3teYm4GLuvNwA6bar1HhKx5YLdrUQNftSJ18L9m9yP-K6sE3N66WTh4R13ue6HedmdpvVEY8SdMgR3mk3MgsuIWzPQ2dOmar4FfGC_h6nTS3kt2ehifjU4hfla0a6M5noaulogIcBA3sbflFUsqK0-7csf-miS3MYrJMiPQoFQTuNtc06HY',
      isActive: false,
      isAdmin: false,
    ),
    _StaffItem(
      name: 'Pham Thi D',
      email: 'phamthid@email.com',
      role: 'Staff',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAXMK_EvDdSkDgeYfWLeoSCoQ3Em5SXEMWLecTw_VtzGK6fKWqRnnq-EHBaxe6XptM9_jsiYPv6d-XiHKo0MLnKNXqxmk_HlqEewfor5bb_8Se7tOSElgny6ZcGOhPpTqPpCxukkvExFMNTQ88-OvNM7rFiRfeNLrtHzqbW4wWbzTj6P-7IhLoMnBz9Y9StPZoUZgXRpNthWRt_2m-1w5TerRXMPN3nbMniUOTDPzYUlMrQsB6-DwuMRp1kK7Q5UR6P15Z5otZYEbQ',
      isActive: true,
      isAdmin: false,
    ),
  ];

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
                  child: ListView.separated(
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
                            setState(() => item.isActive = value);
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
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.isActive,
    required this.isAdmin,
  });

  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  bool isActive;
  final bool isAdmin;
}
