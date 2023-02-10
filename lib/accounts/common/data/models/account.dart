import 'account_id.dart';

abstract class Account {
  final AccountId id;
  final String name;
  final double totalBalance;

  Account({required this.id, required this.name, required this.totalBalance});
}

class DebitAccount extends Account {
  DebitAccount(
      {required AccountId id,
      required String name,
      required double totalBalance})
      : super(id: id, name: name, totalBalance: totalBalance);

  DebitAccount copyWith({String? name, double? totalBalance}) {
    return DebitAccount(
      id: this.id,
      name: name ?? this.name,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }
}

class CreditAccount extends Account {
  final double ownBalance;
  final double creditBalance;

  CreditAccount(
      {required AccountId id,
      required String name,
      required this.ownBalance,
      required this.creditBalance})
      : super(id: id, name: name, totalBalance: ownBalance + creditBalance);

  CreditAccount copyWith(
      {String? name, double? ownBalance, double? creditBalance}) {
    return CreditAccount(
      id: this.id,
      name: name ?? this.name,
      ownBalance: ownBalance ?? this.ownBalance,
      creditBalance: creditBalance ?? this.creditBalance,
    );
  }
}
