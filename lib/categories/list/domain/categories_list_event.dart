import 'package:equatable/equatable.dart';

sealed class CategoriesListEvent extends Equatable {
  const CategoriesListEvent();

  @override
  List<Object> get props => [];
}

final class LoadCategoriesListEvent extends CategoriesListEvent {
  const LoadCategoriesListEvent();
}
