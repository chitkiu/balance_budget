import 'package:flutter/widgets.dart';

import '../../../common/data/models/transaction_type.dart';

class NewCategoryState {
  final TransactionType? type;
  final IconData? icon;
  final String? name;
  final String? error;

  NewCategoryState(this.type, this.icon, this.name, this.error);

  NewCategoryState copyWith(
      {TransactionType? type, IconData? icon, String? name, String? error}) {
    return NewCategoryState(
      type ?? this.type,
      icon ?? this.icon,
      name ?? this.name,
      error ?? this.error,
    );
  }
}
