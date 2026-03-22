class AdminMenuItem {
  const AdminMenuItem({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
  });

  final int id;
  final int categoryId;
  final String categoryName;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final bool isAvailable;

  factory AdminMenuItem.fromJson(Map<String, dynamic> json) {
    final rawImageUrl = (json['imageUrl'] ?? json['ImageUrl'])
        ?.toString()
        .trim();

    return AdminMenuItem(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      categoryId: (json['categoryId'] ?? json['CategoryId'] ?? 0) as int,
      categoryName: (json['categoryName'] ?? json['CategoryName'] ?? '')
          .toString(),
      name: (json['name'] ?? json['Name'] ?? '').toString(),
      description: (json['description'] ?? json['Description'])?.toString(),
      price: (json['price'] ?? json['Price'] ?? 0).toDouble(),
      imageUrl: rawImageUrl?.isNotEmpty == true ? rawImageUrl : null,
      isAvailable:
          (json['isAvailable'] ?? json['IsAvailable'] ?? false) as bool,
    );
  }
}
