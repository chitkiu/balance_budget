import '../../../../categories/common/data/models/category.dart';
import '../../../../wallets/common/data/models/wallet.dart';
import '../../../common/data/models/transaction.dart';

abstract class RichTransactionModel {
  final Transaction transaction;
  final Wallet fromWallet;

  RichTransactionModel(this.transaction, this.fromWallet);
}

class TransferRichTransactionModel extends RichTransactionModel {

  final Wallet toWallet;

  TransferRichTransactionModel(super.transaction, super.fromWallet, this.toWallet);
}

class CategoryRichTransactionModel extends RichTransactionModel {

  final Category category;

  CategoryRichTransactionModel(super.transaction, super.fromWallet, this.category);
}
