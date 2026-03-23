class AdminCategory {
  const AdminCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.displayOrder,
    required this.isActive,
  });

  final int id;
  final String name;
  final String? imageUrl;
  final int displayOrder;
  final bool isActive;

  factory AdminCategory.fromJson(Map<String, dynamic> json) {
    final rawImageUrl = (json['imageUrl'] ?? json['ImageUrl'])?.toString().trim();

    return AdminCategory(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      name: (json['name'] ?? json['Name'] ?? '').toString(),
      imageUrl: rawImageUrl?.isNotEmpty == true ? rawImageUrl : null,
      displayOrder: (json['displayOrder'] ?? json['DisplayOrder'] ?? 0) as int,
      isActive: (json['isActive'] ?? json['IsActive'] ?? false) as bool,
    );
  }
}