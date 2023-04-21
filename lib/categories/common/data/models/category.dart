import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/data/models/icon_converter.dart';
import '../../../../common/data/models/transaction_type.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  @JsonKey(includeFromJson: false)
  String? _id;

  final String title;
  final TransactionType transactionType;
  @IconConverter()
  final IconData icon;
  final bool archived;

  String get id => _id ?? '';

  Category({required this.title, required this.transactionType, this.icon = Icons.not_interested, required this.archived});

  factory Category.fromJson(MapEntry<String, dynamic> entry) =>
      _$CategoryFromJson(entry.value).._id = entry.key;

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({String? title, TransactionType? transactionType, IconData? icon, bool? archived}) {
    return Category(
      title: title ?? this.title,
      transactionType: transactionType ?? this.transactionType,
      icon: icon ?? this.icon,
      archived: archived ?? this.archived,
    )
      .._id = _id;
  }

  @override
  String toString() {
    return 'Category{id: $id, title: $title, transactionType: $transactionType, icon: $icon, archived: $archived}';
  }
}
