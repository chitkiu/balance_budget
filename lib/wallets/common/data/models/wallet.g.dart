// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebitWallet _$DebitWalletFromJson(Map<String, dynamic> json) => DebitWallet(
      name: json['name'] as String,
    );

Map<String, dynamic> _$DebitWalletToJson(DebitWallet instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance._type,
    };

CreditWallet _$CreditWalletFromJson(Map<String, dynamic> json) => CreditWallet(
      name: json['name'] as String,
      creditBalance: (json['creditBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$CreditWalletToJson(CreditWallet instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance._type,
      'creditBalance': instance.creditBalance,
    };
