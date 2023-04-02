abstract class WalletUIModel {
  final String id;
  final String name;
  final String balance;

  WalletUIModel({required this.id, required this.name, required this.balance});
}

class DefaultWalletUIModel extends WalletUIModel {
  DefaultWalletUIModel({required super.id, required super.name, required super.balance});
}

class CreditWalletUIModel extends WalletUIModel {
  final String creditSum;
  final String ownSum;

  CreditWalletUIModel(
      {required this.creditSum,
      required this.ownSum,
      required super.id,
      required super.name,
      required super.balance});
}
