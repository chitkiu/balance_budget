import 'dart:ui';

import 'package:balance_budget/common/getx_extensions.dart';
import 'package:get/get.dart';

abstract class TransactionUIModel {
  final String id;
  final String sum;
  final Color sumColor;
  final String categoryName;
  final String accountName;
  final String time;
  final DateTime dateTime;
  final String? comment;
  final bool canEdit;

  const TransactionUIModel(
      {required this.id,
      required this.sum,
      required this.sumColor,
      required this.categoryName,
      required this.accountName,
      required this.time,
      required this.dateTime,
      this.comment,
      required this.canEdit});
}

class CommonTransactionUIModel extends TransactionUIModel {
  CommonTransactionUIModel(
      {required super.id,
      required super.sum,
      required super.sumColor,
      required super.categoryName,
      required super.accountName,
      required super.time,
      required super.dateTime,
      super.comment})
      : super(canEdit: true);
}

class SetBalanceTransactionUIModel extends TransactionUIModel {
  SetBalanceTransactionUIModel(
      {required super.id,
      required super.sum,
      required super.sumColor,
      required super.accountName,
      required super.time,
      required super.dateTime})
      : super(
            categoryName: Get.localisation.addInitialBudgetCategoryTitle, canEdit: false);
}
