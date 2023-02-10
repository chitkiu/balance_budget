import 'package:flutter/widgets.dart';

import '../../../../common/data/models/transaction_type.dart';
import 'category_id.dart';

class Category {
  final CategoryId id;
  final String title;
  final TransactionType transactionType;
  final IconData? icon;

  Category({required this.id, required this.title, required this.transactionType, this.icon});

  Category copyWith(String? title, TransactionType? transactionType, IconData? icon, CategoryId? rootCategory) {
    return Category(
      id: this.id,
      title: title ?? this.title,
      transactionType: transactionType ?? this.transactionType,
      icon: icon ?? this.icon,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, title: $title, transactionType: $transactionType, icon: $icon}';
  }
}