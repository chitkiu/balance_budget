// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebitAccount _$DebitAccountFromJson(Map<String, dynamic> json) => DebitAccount(
      name: json['name'] as String,
      totalBalance: (json['totalBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$DebitAccountToJson(DebitAccount instance) =>
    <String, dynamic>{
      'name': instance.name,
      'totalBalance': instance.totalBalance,
      'type': instance._type,
    };

CreditAccount _$CreditAccountFromJson(Map<String, dynamic> json) =>
    CreditAccount(
      name: json['name'] as String,
      ownBalance: (json['ownBalance'] as num).toDouble(),
      creditBalance: (json['creditBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$CreditAccountToJson(CreditAccount instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance._type,
      'ownBalance': instance.ownBalance,
      'creditBalance': instance.creditBalance,
    };
