import 'package:equatable/equatable.dart';

sealed class CategoriesListEvent extends Equatable {
  const CategoriesListEvent();

  @override
  List<Object> get props => [];
}

final class LoadCategoriesListEvent extends CategoriesListEvent {
  const LoadCategoriesListEvent();
}

final class AddCategoryEvent extends CategoriesListEvent {
  const AddCategoryEvent();
}

final class CategoryClickEvent extends CategoriesListEvent {
  final String id;
  const CategoryClickEvent(this.id);

  @override
  List<Object> get props => [
    id,
  ];
}
