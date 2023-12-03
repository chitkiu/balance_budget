import 'package:equatable/equatable.dart';

import '../ui/models/category_ui_model.dart';

enum CategoriesListStatus { initial, loading, success, failure }

final class CategoriesListState extends Equatable {
  final CategoriesListStatus status;
  final List<CategoryUIModel> items;
  final String? error;

  const CategoriesListState(this.status, this.items, {this.error});

  CategoriesListState copyWith({
    CategoriesListStatus? status,
    List<CategoryUIModel>? items,
    String? error,
  }) {
    return CategoriesListState(
      status ?? this.status,
      items ?? this.items,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    error,
  ];

}
