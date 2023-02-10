import '../../../../accounts/common/data/models/account_id.dart';

class SpendAccountUIModel {
  final AccountId accountId;
  final String title;
  final bool isSelected;

  SpendAccountUIModel(this.accountId, this.title, this.isSelected);
}