import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/transaction.dart';

class RichTransactionModel {
  final Transaction transaction;
  final Category category;
  final Account account;

  RichTransactionModel(this.transaction, this.category, this.account);
}

class RichTransferTransactionModel extends RichTransactionModel {

  final Account toAccount;

  RichTransferTransactionModel(
      super.transaction,
      super.category,
      super.account,
      this.toAccount
  );
}
