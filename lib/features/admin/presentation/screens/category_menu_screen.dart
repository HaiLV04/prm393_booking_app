import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';
import 'package:prm393_booking_app/core/models/admin_category.dart';
import 'package:prm393_booking_app/core/models/admin_menu_item.dart';
import 'package:prm393_booking_app/features/admin/data/services/category_service.dart';
import 'package:prm393_booking_app/features/admin/data/services/menu_item_service.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/add_category_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/add_menu_item_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/edit_category_screen.dart';
import 'package:prm393_booking_app/features/admin/presentation/screens/edit_menu_item_screen.dart';

class CategoryMenuScreen extends StatefulWidget {
  const CategoryMenuScreen({super.key});

  @override
  State<CategoryMenuScreen> createState() => _CategoryMenuScreenState();
}

class _CategoryMenuScreenState extends State<CategoryMenuScreen>
    with SingleTickerProviderStateMixin {
  late final CategoryService _categoryService;
  late final MenuItemService _menuItemService;
  late final TabController _tabController;
  late Future<List<AdminCategory>> _categoriesFuture;
  late Future<List<AdminMenuItem>> _menuItemsFuture;
  int _currentTabIndex = 0;

  final TextEditingController _menuSearchController = TextEditingController();
  int? _selectedMenuCategoryId;
  String _menuKeyword = '';

  @override
  void initState() {
    super.initState();
    _categoryService = CategoryService();
    _menuItemService = MenuItemService();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChanged);
    _categoriesFuture = _fetchCategories();
    _menuItemsFuture = _fetchMenuItems();
  }

  void _handleTabChanged() {
    if (_currentTabIndex != _tabController.index) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    _menuSearchController.dispose();
    super.dispose();
  }

  Future<void> _refreshCategories() async {
    final future = _fetchCategories();
    setState(() {
      _categoriesFuture = future;
    });
    await future;
  }

  Future<List<AdminCategory>> _fetchCategories() async {
    return _categoryService.getAllCategories();
  }

  Future<List<AdminMenuItem>> _fetchMenuItems() async {
    return _menuItemService.getMenuItems(
      categoryId: _selectedMenuCategoryId,
      keyword: _menuKeyword,
      pageSize: 100,
    );
  }

  Future<void> _refreshMenuItems() async {
    final future = _fetchMenuItems();
    setState(() {
      _menuItemsFuture = future;
    });
    await future;
  }

  Future<void> _openEditCategory(AdminCategory category) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditCategoryScreen(
          categoryId: category.id,
          categoryService: _categoryService,
        ),
      ),
    );

    if (updated == true && mounted) {
      await _refreshCategories();
    }
  }

  Future<void> _openAddCategory() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddCategoryScreen(categoryService: _categoryService),
      ),
    );

    if (created == true && mounted) {
      await _refreshCategories();
    }
  }

  void _selectMenuCategory(int? categoryId) {
    setState(() {
      _selectedMenuCategoryId = categoryId;
    });
    _refreshMenuItems();
  }

  void _searchMenuItems(String value) {
    setState(() {
      _menuKeyword = value.trim();
    });
    _refreshMenuItems();
  }

  Future<void> _openEditMenuItem(
    AdminMenuItem item,
    List<AdminCategory> categories,
  ) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditMenuItemScreen(
          menuItem: item,
          categories: categories,
          menuItemService: _menuItemService,
        ),
      ),
    );

    if (updated == true && mounted) {
      await _refreshMenuItems();
    }
  }

  Future<void> _openAddMenuItem() async {
    final categories = await _fetchCategories();
    if (!mounted) {
      return;
    }

    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddMenuItemScreen(
          categories: categories,
          menuItemService: _menuItemService,
        ),
      ),
    );

    if (created == true && mounted) {
      await _refreshMenuItems();
      await _refreshCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Quản lý thực đơn',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              Container(color: AppColors.primary.withOpacity(0.1), height: 1.0),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.textMain,
                unselectedLabelColor: AppColors.textSub,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Danh mục'),
                  Tab(text: 'Món ăn'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<AdminCategory>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 80),
                const Icon(
                  Icons.error_outline,
                  size: 40,
                  color: AppColors.textSub,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Không tải được danh mục',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSub),
                ),
              ],
            );
          }

          final categories = snapshot.data ?? <AdminCategory>[];
          return TabBarView(
            controller: _tabController,
            children: [
              _buildCategoryTab(categories),
              _buildMenuItemsTab(categories),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _currentTabIndex == 0 ? _openAddCategory : _openAddMenuItem,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.surfaceLight),
      ),
    );
  }

  Widget _buildCategoryTab(List<AdminCategory> categories) {
    if (categories.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshCategories,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: const [
            SizedBox(height: 80),
            Icon(Icons.category_outlined, size: 40, color: AppColors.textSub),
            SizedBox(height: 12),
            Text(
              'Chưa có danh mục nào',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshCategories,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(context, category);
        },
      ),
    );
  }

  Widget _buildMenuItemsTab(List<AdminCategory> categories) {
    return RefreshIndicator(
      onRefresh: _refreshMenuItems,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.08)),
            ),
            child: TextField(
              controller: _menuSearchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _searchMenuItems,
              onChanged: (value) {
                if (value.trim().isEmpty && _menuKeyword.isNotEmpty) {
                  _searchMenuItems('');
                }
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm món ăn',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () => _searchMenuItems(_menuSearchController.text),
                  icon: const Icon(Icons.arrow_forward),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.08)),
            ),
            child: DropdownButtonFormField<int?>(
              value: categories.any((c) => c.id == _selectedMenuCategoryId)
                  ? _selectedMenuCategoryId
                  : null,
              decoration: const InputDecoration(
                labelText: 'Danh mục',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Tất cả'),
                ),
                ...categories.map(
                  (category) => DropdownMenuItem<int?>(
                    value: category.id,
                    child: Text(category.name),
                  ),
                ),
              ],
              onChanged: (value) => _selectMenuCategory(value),
            ),
          ),
          const SizedBox(height: 14),
          FutureBuilder<List<AdminMenuItem>>(
            future: _menuItemsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.textSub),
                      const SizedBox(height: 8),
                      Text(
                        'Không tải được món ăn: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSub),
                      ),
                    ],
                  ),
                );
              }

              final items = snapshot.data ?? <AdminMenuItem>[];
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'Không có món ăn phù hợp',
                      style: TextStyle(color: AppColors.textSub),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildMenuItemCard(
                    item,
                    onTap: () => _openEditMenuItem(item, categories),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemCard(AdminMenuItem item, {required VoidCallback onTap}) {
    final hasImage = (item.imageUrl?.isNotEmpty ?? false);
    final isOut = !item.isAvailable;

    return Opacity(
      opacity: isOut ? 0.78 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: hasImage
                            ? null
                            : AppColors.textSub.withOpacity(0.16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.08),
                        ),
                        image: hasImage
                            ? DecorationImage(
                                image: NetworkImage(item.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    if (isOut)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.38),
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.58),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Hết hàng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_formatVnd(item.price)}đ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isOut ? AppColors.textSub : AppColors.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOut
                        ? Colors.red.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isOut ? 'Hết hàng' : 'Còn hàng',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isOut ? Colors.red : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatVnd(double value) {
    final text = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    var count = 0;
    for (var i = text.length - 1; i >= 0; i--) {
      buffer.write(text[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }
    return buffer.toString().split('').reversed.join();
  }

  Widget _buildCategoryCard(BuildContext context, AdminCategory category) {
    final hasImage = (category.imageUrl?.isNotEmpty ?? false);
    final isInactive = !category.isActive;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to category details or menu items
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: hasImage ? null : AppColors.textSub.withOpacity(0.16),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                image: hasImage
                    ? DecorationImage(
                        image: NetworkImage(category.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: hasImage
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        )
                      : null,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _openEditCategory(category),
                          tooltip: 'Sửa danh mục',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.18),
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isInactive)
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.32),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            if (isInactive)
              Positioned(
                top: 10,
                left: 10,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Tạm ẩn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
