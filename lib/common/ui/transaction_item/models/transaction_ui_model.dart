import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/getx_extensions.dart';

abstract class TransactionUIModel {
  final String id;
  final String sum;
  final double sumDouble;
  final Color sumColor;
  final String categoryName;
  final String fromWalletName;
  final String fromWalletId;
  final String formattedDate;
  final DateTime dateTime;
  final String? comment;
  final bool canEdit;
  final IconData icon;

  const TransactionUIModel(
      {required this.id,
      required this.sum,
      required this.sumDouble,
      required this.sumColor,
      required this.categoryName,
      required this.fromWalletName,
      required this.fromWalletId,
      required this.formattedDate,
      required this.dateTime,
      this.comment,
      required this.canEdit,
      required this.icon});
}

class CommonTransactionUIModel extends TransactionUIModel {
  final String categoryId;

  CommonTransactionUIModel(
      {required super.id,
      required super.sum,
      required super.sumDouble,
      required super.sumColor,
      required super.categoryName,
      required this.categoryId,
      required super.fromWalletName,
      required super.fromWalletId,
      required super.formattedDate,
      required super.dateTime,
      super.comment,
      required super.icon})
      : super(canEdit: true);
}

class TransferTransactionUIModel extends TransactionUIModel {
  final String toWalletName;
  final String toWalletId;

  TransferTransactionUIModel(
      {required super.id,
      required super.sum,
      required super.sumDouble,
      required super.fromWalletName,
      required super.fromWalletId,
      required this.toWalletName,
      required this.toWalletId,
      required super.formattedDate,
      required super.dateTime})
      : super(
            categoryName: Get.localisation.transferCategoryTitle,
            canEdit: false,
            sumColor: Colors.grey,
            icon: Icons.compare_arrows);
}
