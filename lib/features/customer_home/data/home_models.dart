import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final bool active;

  const CategoryItem({
    required this.name,
    required this.icon,
    required this.active,
  });
}

class DishItem {
  final String name;
  final String description;
  final String price;
  final String image;

  const DishItem({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
}
