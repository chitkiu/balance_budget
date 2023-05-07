import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

abstract class Wallet {
  @JsonKey(includeFromJson: false)
  String? _id;
  final String name;
  final bool archived;

  String get id => _id ?? '';

  Wallet({required this.name, required this.archived});

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

  @override
  String toString() {
    return 'Wallet{_id: $_id, name: $name, archived: $archived}';
  }
}

@JsonSerializable()
class DebitWallet extends Wallet {
  DebitWallet({required super.name, required super.archived});

  factory DebitWallet.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$DebitWalletFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$DebitWalletToJson(this);

  DebitWallet copyWith({String? name, bool? archived}) {
    return DebitWallet(
      name: name ?? this.name,
      archived: archived ?? this.archived,
    ).._id = _id;
  }
}

@JsonSerializable()
class CreditWallet extends Wallet {
  final double creditBalance;

  CreditWallet({required super.name, required this.creditBalance, required super.archived});

  factory CreditWallet.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$CreditWalletFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$CreditWalletToJson(this);

  CreditWallet copyWith({String? name, double? creditBalance, bool? archived}) {
    return CreditWallet(
      name: name ?? this.name,
      creditBalance: creditBalance ?? this.creditBalance,
      archived: archived ?? this.archived,
    ).._id = _id;
  }
}
