import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/transaction_item/mappers/transactions_header_ui_mapper.dart';
import '../../../common/ui/transaction_item/mappers/transactions_ui_mapper.dart';
import '../../../transactions/common/data/models/rich_transaction_model.dart';
import '../../../transactions/common/data/rich_transaction_comparator.dart';
import '../../../transactions/info/domain/transaction_info_controller.dart';
import '../../../transactions/info/ui/transaction_info_screen.dart';
import '../../common/data/local_category_repository.dart';
import '../../common/data/models/category.dart';
import '../../list/domain/mappers/category_ui_mapper.dart';
import '../data/category_transactions_aggregator.dart';
import '../ui/models/rich_category_ui_model.dart';
import 'category_info_event.dart';
import 'category_info_status.dart';

class CategoryInfoBloc extends Bloc<CategoryInfoEvent, CategoryInfoState> {

  final LocalCategoryRepository _categoryRepo;
  final CategoryTransactionsAggregator _transactionsAggregator = const CategoryTransactionsAggregator();

  final _categoryUIMapper = const CategoryUIMapper();

  final TransactionsHeaderUIMapper _transactionsHeaderUIMapper =
  TransactionsHeaderUIMapper(
    const RichTransactionComparator(),
    TransactionsUIMapper(),
  );

  CategoryInfoBloc(this._categoryRepo) : super(
      const CategoryInfoState(CategoryInfoStatus.initial, null, error: null)
  ) {
    on<LoadCategoryEvent>(_onLoad);
    on<ChangeArchiveStatusOnCategoryEvent>(_onChangeArchiveStatus);
    on<DeleteCategoryEvent>(_onDelete);
    on<TransactionClickInCategoryEvent>(_onTransactionClick);
  }

  Future<void> _onChangeArchiveStatus(
      ChangeArchiveStatusOnCategoryEvent event,
      Emitter<CategoryInfoState> emit,
      ) async {
    final category = await _categoryRepo.getCategoryById(event.id);

    if (category != null) {
      await _categoryRepo.edit(category.id, archived: !category.archived);
    }
  }

  Future<void> _onDelete(
      DeleteCategoryEvent event,
      Emitter<CategoryInfoState> emit,
      ) async {
    await _categoryRepo.delete(event.id);
  }

  Future<void> _onTransactionClick(
      TransactionClickInCategoryEvent event,
      Emitter<CategoryInfoState> emit,
      ) async {
    openModalSheetWithController(
      Get.context!,
          (controller) {
        return TransactionInfoScreen(controller: controller,);
      },
      TransactionInfoController(event.transaction.id, event.canEdit),
    );
  }

  Future<void> _onLoad(
      LoadCategoryEvent event,
      Emitter<CategoryInfoState> emit,
      ) async {

    emit(state.copyWith(status: CategoryInfoStatus.loading));

    await emit.forEach(
        _getStream(event.id),
      onData: (data) {
          if (data != null) {
            return state.copyWith(
              status: CategoryInfoStatus.success,
              model: data,
              error: null,
            );
          } else {
            return state.copyWith(
              status: CategoryInfoStatus.failure,
              error: "Something wrong with category ${event.id}",
            );
          }
      },
      onError: (_, str) => state.copyWith(
        status: CategoryInfoStatus.failure,
        error: str.toString(),
      ),
    );
  }

  Stream<RichCategoryUIModel?> _getStream(String id) {
    return _categoryRepo.categoryById(id).switchMap((category) {
      if (category == null) {
        return Stream.value(null);
      } else {
        return _transactionsAggregator
            .transactionByCategoryId(category.id)
            .map((transactions) => _mapToUIModel(category, transactions));
      }
    });
  }

  RichCategoryUIModel _mapToUIModel(
      Category category, List<RichTransactionModel> transactions) {
    return RichCategoryUIModel(
        _categoryUIMapper.map(category),
        _transactionsHeaderUIMapper.mapTransactionsToUI(transactions));
  }



}