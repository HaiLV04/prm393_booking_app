class MenuCategory {
  final String name;
  final bool active;

  const MenuCategory({required this.name, required this.active});
}

class MenuDish {
  final String title;
  final String description;
  final String price;
  final String imageUrl;

  const MenuDish({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
