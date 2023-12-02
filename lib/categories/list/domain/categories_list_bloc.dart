import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../add/ui/add_category_screen.dart';
import '../../common/data/local_category_repository.dart';
import '../../info/ui/category_info_screen.dart';
import '../ui/models/category_ui_model.dart';
import 'categories_list_event.dart';
import 'categories_list_status.dart';
import 'mappers/category_ui_mapper.dart';

//TODO Maybe rewrite to Cubit
class CategoriesListBloc extends Bloc<CategoriesListEvent, CategoriesListState> {

  final LocalCategoryRepository _categoryRepository;
  final _mapper = const CategoryUIMapper();

  CategoriesListBloc(this._categoryRepository) : super(
      CategoriesListState(CategoriesListStatus.initial, List.empty())
  ) {
    on<LoadCategoriesListEvent>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddClick);
    on<CategoryClickEvent>(_onCategoryClick);
  }

  Future<void> _onAddClick(
      AddCategoryEvent event,
      Emitter<CategoriesListState> emit,
      ) async {
    Get.to(
          () => const AddCategoryScreen(),
    );
  }

  Future<void> _onCategoryClick(
      CategoryClickEvent event,
      Emitter<CategoriesListState> emit,
      ) async {
    Get.to(() => CategoryInfoScreen(event.id));
  }

  Future<void> _onLoadCategories(
      LoadCategoriesListEvent event,
      Emitter<CategoriesListState> emit,
      ) async {
    emit(state.copyWith(status: CategoriesListStatus.loading));

    await emit.forEach<List<CategoryUIModel>>(
      _getCategories(),
      onData: (items) => state.copyWith(
        status: CategoriesListStatus.success,
        items: items,
      ),
      onError: (_, str) => state.copyWith(
        status: CategoriesListStatus.failure,
        error: str.toString(),
      ),
    );
  }

  Stream<List<CategoryUIModel>> _getCategories() {
    return _categoryRepository.categories.map((event) {
      return event
          .where((category) =>
          TransactionType.canAddCategory.contains(category.transactionType))
          .map(_mapper.map)
          .toList();
    });
  }

}