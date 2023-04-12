import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/getx_extensions.dart';

abstract class TransactionUIModel {
  final String id;
  final String sum;
  final double sumDouble;
  final Color sumColor;
  final String categoryName;
  final String walletName;
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
      required this.walletName,
      required this.formattedDate,
      required this.dateTime,
      this.comment,
      required this.canEdit,
      required this.icon});
}

class CommonTransactionUIModel extends TransactionUIModel {
  CommonTransactionUIModel(
      {required super.id,
      required super.sum,
      required super.sumDouble,
      required super.sumColor,
      required super.categoryName,
      required super.walletName,
      required super.formattedDate,
      required super.dateTime,
      super.comment,
      required super.icon})
      : super(canEdit: true);
}

class TransferTransactionUIModel extends TransactionUIModel {
  final String fromWalletName;
  final String toWalletName;

  TransferTransactionUIModel(
      {required super.id,
      required super.sum,
      required super.sumDouble,
      required this.fromWalletName,
      required this.toWalletName,
      required super.formattedDate,
      required super.dateTime})
      : super(
            categoryName: Get.localisation.transferCategoryTitle,
            canEdit: false,
            walletName: fromWalletName,
            sumColor: Colors.grey,
            icon: Icons.compare_arrows);
}
