import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/customer_home/data/home_models.dart';

const categories = [
  CategoryItem(name: 'Mains', icon: Icons.restaurant, active: true),
  CategoryItem(name: 'Appetizers', icon: Icons.tapas, active: false),
  CategoryItem(name: 'Drinks', icon: Icons.local_bar, active: false),
  CategoryItem(name: 'Desserts', icon: Icons.icecream, active: false),
  CategoryItem(name: 'Vegan', icon: Icons.eco, active: false),
];

const featuredDishes = [
  DishItem(
    name: 'Mushroom Risotto',
    description: 'Creamy arborio rice with wild mushrooms',
    price: r'$14.00',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAN4dfIHhEskuOujh_chkrezL5gsl-x45sMUZcXQhJdQda0h6RdHrterYqcXLzjZ8mjIBFgWUREuGFYIVVlNxj_gEfvPmqzcN8qBH-WcrD1FbM-rgK5TnCnfty5d7ZprzDAXORyC_lseXDM_PcIjA1yhWxWGtAs3kZJb7KbHVy6a7o0GBFxYF-a8N_IdtR-z5Ow87G20oPmuQdAve3fl6eUyBx2Vua66JPTyLesQ49N9QsWZvljZIUtkw7qR31L5gRtXOwmzyadkNg',
  ),
  DishItem(
    name: 'Classic Beef Burger',
    description: 'Angus beef patty with cheddar cheese',
    price: r'$12.50',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA6455GEbfQCBLAxms38RMTXd-F2WSkTlPBvE43WRVX38rG300wPg5XC-rzs6wB3zC0N1BJEYe-bsD7W6IHFWAGrdKZM8iO7Co8YQHR1fChGy88rG9nk3Q6xm0WHVKdKuw5aHlmNuBuWqyKzod8kHf3QlSARjSAd1arCwbjW79DoBBwX3cQVFrHYeJr31nFJXGeDSc5AId68Ee9DOPc3kMuAbvlOdK3uh0xuLzVYB52hvO9VgNPYPbGaWLbT0gFoM50FfeeacDOsHI',
  ),
  DishItem(
    name: 'Caesar Salad',
    description: 'Fresh romaine lettuce with croutons',
    price: r'$10.00',
    image:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCwkJlkSR2sD6YLq6W0gPvZzhm2I5DCi6PeisxgOPQXhyPshJ_7kOBy4RUWw5Z78ypmqGa4wyc17jLJJRX499WdxI5lmnKELZR12r14FiC1za7e5KuaHt2W8sBvKNs1hAIvJeTRiB81ajDye0DZoTEwbRKEK1f0XUKZX5e0TypiuSVD1j3CNzen_F13noJyRuUFeEkvDmgOxgh0YIRE5hHLYDc7K4vpaVxcvPIcXlpA5ShVIQbKwJ1G0azKhxtDol7aoRnScbch6gI',
  ),
];
