import 'package:balance_budget/common/getx_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'transaction_list_ui_model.dart';

abstract class TransactionUIModel extends TransactionListUIModel {
  final String id;
  final String sum;
  final double sumDouble;
  final Color sumColor;
  final String categoryName;
  final String accountName;
  final String formattedDate;
  final DateTime dateTime;
  final String? comment;
  final bool canEdit;

  const TransactionUIModel(
      {required this.id,
      required this.sum,
      required this.sumDouble,
      required this.sumColor,
      required this.categoryName,
      required this.accountName,
      required this.formattedDate,
      required this.dateTime,
      this.comment,
      required this.canEdit});
}

class CommonTransactionUIModel extends TransactionUIModel {
  CommonTransactionUIModel(
      {required super.id,
      required super.sum,
      required super.sumDouble,
      required super.sumColor,
      required super.categoryName,
      required super.accountName,
      required super.formattedDate,
      required super.dateTime,
      super.comment})
      : super(canEdit: true);
}

class TransferTransactionUIModel extends TransactionUIModel {
  final String fromAccountName;
  final String toAccountName;

  TransferTransactionUIModel(
      {required super.id,
      required super.sum,
      required super.sumDouble,
      required this.fromAccountName,
      required this.toAccountName,
      required super.formattedDate,
      required super.dateTime})
      : super(
            categoryName: Get.localisation.transferCategoryTitle,
            canEdit: false,
            accountName: fromAccountName,
            sumColor: Colors.grey);
}
