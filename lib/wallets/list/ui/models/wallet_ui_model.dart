abstract class WalletUIModel {
  final String id;
  final String name;
  final String balance;
  final bool isArchived;

  WalletUIModel({required this.id, required this.name, required this.balance, required this.isArchived});
}

class DefaultWalletUIModel extends WalletUIModel {
  DefaultWalletUIModel(
      {required super.id, required super.name, required super.balance, required super.isArchived});
}

class CreditWalletUIModel extends WalletUIModel {
  final String totalCreditSum;
  final String spendCreditSum;
  final String ownSum;

  CreditWalletUIModel(
      {required this.totalCreditSum,
      required this.spendCreditSum,
      required this.ownSum,
      required super.id,
      required super.name,
      required super.balance,
      required super.isArchived});
}
