import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/transaction.dart';

class RichTransactionModel {
  final Transaction transaction;
  final Category category;
  final Account account;

  RichTransactionModel(this.transaction, this.category, this.account);
}