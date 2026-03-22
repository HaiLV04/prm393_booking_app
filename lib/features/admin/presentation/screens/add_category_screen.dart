import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/constants/app_colors.dart';
import 'package:prm393_booking_app/features/admin/data/services/category_service.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key, required this.categoryService});

  final CategoryService categoryService;

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _displayOrderController = TextEditingController(text: '0');

  bool _isSaving = false;
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final createdCategory = await widget.categoryService.createCategory(
        name: _nameController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        displayOrder: int.tryParse(_displayOrderController.text.trim()) ?? 0,
      );

      if (!_isActive) {
        await widget.categoryService.toggleCategoryActive(
          categoryId: createdCategory.id,
          isActive: false,
        );
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tạo danh mục thành công')));
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể tạo danh mục: $error')));

      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: const Text(
          'Thêm danh mục',
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Tên danh mục'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nhập tên danh mục'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tên danh mục là bắt buộc';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildLabel('Image URL'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageUrlController,
                decoration: _inputDecoration('https://example.com/image.jpg'),
              ),
              const SizedBox(height: 16),
              _buildLabel('Thứ tự hiển thị'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _displayOrderController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('0'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Đang hoạt động',
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Tắt nếu muốn tạo sẵn ở trạng thái tạm ẩn',
                  style: TextStyle(color: AppColors.textSub),
                ),
                value: _isActive,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textMain,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Tạo danh mục',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.12)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }
}
