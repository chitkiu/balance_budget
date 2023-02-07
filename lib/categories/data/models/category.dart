import 'package:flutter/widgets.dart';

import 'category_id.dart';

class Category {
  final CategoryId id;
  final String title;
  final IconData? icon;
  final CategoryId? rootCategory;

  Category({required this.id, required this.title, this.icon, this.rootCategory});

  Category copyWith(String? title, IconData? icon, CategoryId? rootCategory) {
    return Category(
      id: this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      rootCategory: rootCategory ?? this.rootCategory,
    );
  }
}