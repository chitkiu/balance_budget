import 'package:equatable/equatable.dart';

import '../../../common/ui/transaction_item/models/transaction_ui_model.dart';

sealed class CategoryInfoEvent extends Equatable {
  const CategoryInfoEvent();

  @override
  List<Object> get props => [];
}

final class LoadCategoryEvent extends CategoryInfoEvent {
  final String id;
  const LoadCategoryEvent(this.id);

  @override
  List<Object> get props => [
    id,
  ];
}

final class ChangeArchiveStatusOnCategoryEvent extends CategoryInfoEvent {
  final String id;
  const ChangeArchiveStatusOnCategoryEvent(this.id);

  @override
  List<Object> get props => [
    id,
  ];
}

final class DeleteCategoryEvent extends CategoryInfoEvent {
  final String id;
  const DeleteCategoryEvent(this.id);

  @override
  List<Object> get props => [
    id,
  ];
}

final class TransactionClickInCategoryEvent extends CategoryInfoEvent {
  final TransactionUIModel transaction;
  final bool canEdit;

  const TransactionClickInCategoryEvent(this.transaction, this.canEdit);

  @override
  List<Object> get props => [
    transaction,
    canEdit,
  ];
}
