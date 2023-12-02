import 'package:equatable/equatable.dart';

import '../ui/models/rich_category_ui_model.dart';

enum CategoryInfoStatus { initial, loading, success, failure }

final class CategoryInfoState extends Equatable {
  final CategoryInfoStatus status;
  final RichCategoryUIModel? model;
  final String? error;

  const CategoryInfoState(this.status, this.model, {this.error});

  CategoryInfoState copyWith({
    CategoryInfoStatus? status,
    RichCategoryUIModel? model,
    String? error,
  }) {
    return CategoryInfoState(
      status ?? this.status,
      model ?? this.model,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    model,
    error,
  ];

}