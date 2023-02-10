import '../../../../accounts/common/data/models/account_id.dart';

class TransactionAccountUIModel {
  final AccountId accountId;
  final String title;
  final bool isSelected;

  TransactionAccountUIModel(this.accountId, this.title, this.isSelected);
}