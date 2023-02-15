abstract class AccountUIModel {
  final String id;
  final String name;
  final String balance;

  AccountUIModel({required this.id, required this.name, required this.balance});
}

class DefaultAccountUIModel extends AccountUIModel {
  DefaultAccountUIModel({required super.id, required super.name, required super.balance});
}

class CreditAccountUIModel extends AccountUIModel {
  final String creditSum;
  final String ownSum;

  CreditAccountUIModel(
      {required this.creditSum,
      required this.ownSum,
      required super.id,
      required super.name,
      required super.balance});
}
