import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/transaction.dart';

abstract class RichTransactionModel {
  final Transaction transaction;
  final Account fromAccount;

  RichTransactionModel(this.transaction, this.fromAccount);
}

class TransferRichTransactionModel extends RichTransactionModel {

  final Account toAccount;

  TransferRichTransactionModel(super.transaction, super.fromAccount, this.toAccount);
}

class SetBalanceRichTransactionModel extends RichTransactionModel {
  SetBalanceRichTransactionModel(super.transaction, super.fromAccount);
}

class CategoryRichTransactionModel extends RichTransactionModel {

  final Category category;

  CategoryRichTransactionModel(super.transaction, super.fromAccount, this.category);
}
