import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CategoryMenuScreen: Admin manages menu items and categories
/// Business Logic:
/// 1. View all categories and menu items
/// 2. Add/Edit/Delete menu items
/// 3. Toggle menu item availability (còn/hết)
/// 4. Filter items by category
/// 5. Search menu items by name
class CategoryMenuScreen extends StatefulWidget {
  const CategoryMenuScreen({super.key});

  @override
  State<CategoryMenuScreen> createState() => _CategoryMenuScreenState();
}

class _CategoryMenuScreenState extends State<CategoryMenuScreen> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String? _selectedCategoryId;
  late TabController _tabController;
  bool _isLoading = false;

  static const Color _primary = Color(0xFF13EC5B);
  static const Color _bgDark = Color(0xFF102216);
  static const Color _surfaceDark = Color(0xFF1C2E21);
  static const Color _textSecondary = Color(0xFF9DB9A6);
  static const Color _danger = Color(0xFFEF4444);

  /// Mock categories
  final List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Món khai vị', 'itemCount': 8},
    {'id': '2', 'name': 'Món chính', 'itemCount': 15},
    {'id': '3', 'name': 'Tráng miệng', 'itemCount': 6},
    {'id': '4', 'name': 'Đồ uống', 'itemCount': 12},
  ];

  /// Mock menu items
  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': '1',
      'name': 'Cơm mực',
      'category': '2',
      'price': 150000,
      'available': true,
      'description': 'Cơm rang tôm nhân cá mực tươi',
    },
    {
      'id': '2',
      'name': 'Salad rau xanh',
      'category': '1',
      'price': 85000,
      'available': true,
      'description': 'Salad rau tươi tây với nước sốt truyền thống',
    },
    {
      'id': '3',
      'name': 'Kem tiramisu',
      'category': '3',
      'price': 60000,
      'available': false,
      'description': 'Kem tiramisu Ý truyền thống',
    },
    {
      'id': '4',
      'name': 'Nước ép cam',
      'category': '4',
      'price': 45000,
      'available': true,
      'description': 'Nước ép cam tươi 100%',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddMenuItemDialog() {
    // TODO: Implement dialog to add menu item
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng thêm món sẽ được triển khai')),
    );
  }

  void _toggleMenuItemAvailability(String itemId, bool currentStatus) {
    setState(() {
      final item = _menuItems.firstWhere((item) => item['id'] == itemId);
      item['available'] = !currentStatus;
    });

    // API Call Implementation:
    // - PATCH /api/menu-items/{itemId}/availability
    // - Body: { isAvailable: boolean }
    // - Response: { success, message }
    // - Use: final menuItemService = MenuItemService(apiClient: context.read<ApiClient>());
    //        await menuItemService.toggleAvailability(itemId: itemId, isAvailable: newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? _bgDark : const Color(0xFFF6F8F6);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? _textSecondary : const Color(0xFF64748B);
    final surfaceColor = isDark ? _surfaceDark : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(textColor, isDark),

            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: _primary,
              unselectedLabelColor: subtitleColor,
              indicatorColor: _primary,
              tabs: const [
                Tab(text: 'Danh mục'),
                Tab(text: 'Tất cả món'),
              ],
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Categories Tab
                  _buildCategoriesTab(textColor, subtitleColor, surfaceColor, isDark),

                  // Menu Items Tab
                  _buildMenuItemsTab(textColor, subtitleColor, surfaceColor, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenuItemDialog,
        backgroundColor: _primary,
        child: const Icon(Icons.add, color: _bgDark),
      ),
    );
  }

  Widget _buildHeader(Color textColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? _surfaceDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8E4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: textColor),
          ),
          const SizedBox(width: 16),
          Text(
            'Quản lý Menu',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab(
    Color textColor,
    Color subtitleColor,
    Color surfaceColor,
    bool isDark,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return GestureDetector(
          onTap: () {
            setState(() => _selectedCategoryId = category['id']);
            _tabController.animateTo(1);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: _selectedCategoryId == category['id']
                  ? Border.all(color: _primary, width: 2)
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['name'],
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${category['itemCount']} món',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: subtitleColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItemsTab(
    Color textColor,
    Color subtitleColor,
    Color surfaceColor,
    bool isDark,
  ) {
    final filteredItems = _menuItems.where((item) {
      final matchesCategory = _selectedCategoryId == null || item['category'] == _selectedCategoryId;
      final matchesSearch = _searchQuery.isEmpty ||
          item['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm món ăn...',
              hintStyle: GoogleFonts.outfit(color: subtitleColor),
              prefixIcon: Icon(Icons.search, color: subtitleColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: subtitleColor),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        // Menu Items List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return _buildMenuItemCard(
                item,
                textColor,
                subtitleColor,
                surfaceColor,
                isDark,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItemCard(
    Map<String, dynamic> item,
    Color textColor,
    Color subtitleColor,
    Color surfaceColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon or Image Placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF13EC5B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.restaurant,
              color: _primary,
            ),
          ),
          const SizedBox(width: 12),
          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['price'].toStringAsFixed(0)} đ',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _primary,
                      ),
                    ),
                    // Availability Toggle
                    GestureDetector(
                      onTap: () {
                        _toggleMenuItemAvailability(
                          item['id'],
                          item['available'],
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item['available']
                              ? _primary.withOpacity(0.1)
                              : _danger.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['available'] ? 'Còn' : 'Hết',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: item['available'] ? _primary : _danger,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Edit/Delete buttons
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Sửa'),
                onTap: () {
                  // TODO: Edit menu item
                },
              ),
              PopupMenuItem(
                child: const Text('Xóa'),
                onTap: () {
                  // TODO: Delete menu item with confirmation
                },
              ),
            ],
            child: Icon(Icons.more_vert, color: subtitleColor),
          ),
        ],
      ),
    );
  }
}
