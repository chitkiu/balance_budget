import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

abstract class Wallet {
  @JsonKey(includeFromJson: false)
  String? _id;
  final String name;

  String get id => _id ?? '';

  Wallet({required this.name});

  @JsonKey(
      name: _typeName,
      includeToJson: true
  )
  String get _type => runtimeType.toString();

  Map<String, dynamic> toJson();

  static const String _typeName = "type";

  static Wallet fromJson(MapEntry<dynamic, dynamic> json) {
    if (json.value[_typeName] == (CreditWallet).toString()) {
      return CreditWallet.fromJson(json);
    } else {
      return DebitWallet.fromJson(json);
    }
  }
}

@JsonSerializable()
class DebitWallet extends Wallet {
  DebitWallet({required super.name});

  factory DebitWallet.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$DebitWalletFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$DebitWalletToJson(this);

  DebitWallet copyWith({String? name}) {
    return DebitWallet(
      name: name ?? this.name,
    ).._id = _id;
  }
}

@JsonSerializable()
class CreditWallet extends Wallet {
  final double creditBalance;

  CreditWallet({required super.name, required this.creditBalance});

  factory CreditWallet.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$CreditWalletFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$CreditWalletToJson(this);

  CreditWallet copyWith({String? name, double? ownBalance, double? creditBalance}) {
    return CreditWallet(
      name: name ?? this.name,
      creditBalance: creditBalance ?? this.creditBalance,
    ).._id = _id;
  }
}
