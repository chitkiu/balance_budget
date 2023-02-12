import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/data/models/transaction_type.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  @JsonKey(includeFromJson: false)
  late final String? _id;

  final String title;
  final TransactionType transactionType;

  String get id => _id!;

  // final IconData? icon;

  Category({required this.title, required this.transactionType /*, this.icon*/});

  factory Category.fromJson(MapEntry<String, dynamic> entry) =>
      _$CategoryFromJson(entry.value).._id = entry.key;

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith(String? title, TransactionType? transactionType, IconData? icon) {
    return Category(
      title: title ?? this.title,
      transactionType: transactionType ?? this.transactionType,
      // icon: icon ?? this.icon,
    ).._id = _id;
  }

  @override
  String toString() {
    return 'Category{id: $id, title: $title, transactionType: $transactionType}';
  }
}
