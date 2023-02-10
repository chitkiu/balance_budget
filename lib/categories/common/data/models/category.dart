import 'package:flutter/widgets.dart';

import 'category_id.dart';

class Category {
  final CategoryId id;
  final String title;
  final IconData? icon;

  Category({required this.id, required this.title, this.icon});

  Category copyWith(String? title, IconData? icon, CategoryId? rootCategory) {
    return Category(
      id: this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, title: $title, icon: $icon}';
  }
}