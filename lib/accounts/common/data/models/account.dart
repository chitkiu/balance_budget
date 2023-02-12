import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

abstract class Account {
  @JsonKey(includeFromJson: false)
  late final String? _id;
  final String name;
  final double totalBalance;

  String get id => _id!;

  Account({required this.name, required this.totalBalance});

  static Account fromJson(MapEntry<dynamic, dynamic> json) {
    if (json.value['creditBalance'] != null) {
      return CreditAccount.fromJson(json);
    } else {
      return DebitAccount.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class DebitAccount extends Account {
  DebitAccount({required String name, required double totalBalance})
      : super(name: name, totalBalance: totalBalance);

  factory DebitAccount.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$DebitAccountFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$DebitAccountToJson(this);

  DebitAccount copyWith({String? name, double? totalBalance}) {
    return DebitAccount(
      name: name ?? this.name,
      totalBalance: totalBalance ?? this.totalBalance,
    ).._id = _id;
  }
}

@JsonSerializable()
class CreditAccount extends Account {
  final double ownBalance;
  final double creditBalance;

  CreditAccount(
      {required String name,
      required this.ownBalance,
      required this.creditBalance})
      : super(name: name, totalBalance: ownBalance + creditBalance);

  factory CreditAccount.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$CreditAccountFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$CreditAccountToJson(this);

  CreditAccount copyWith({String? name, double? ownBalance, double? creditBalance}) {
    return CreditAccount(
      name: name ?? this.name,
      ownBalance: ownBalance ?? this.ownBalance,
      creditBalance: creditBalance ?? this.creditBalance,
    ).._id = _id;
  }
}
