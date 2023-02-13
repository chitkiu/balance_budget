// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebitAccount _$DebitAccountFromJson(Map<String, dynamic> json) => DebitAccount(
      name: json['name'] as String,
    );

Map<String, dynamic> _$DebitAccountToJson(DebitAccount instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance._type,
    };

CreditAccount _$CreditAccountFromJson(Map<String, dynamic> json) =>
    CreditAccount(
      name: json['name'] as String,
      creditBalance: (json['creditBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$CreditAccountToJson(CreditAccount instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance._type,
      'creditBalance': instance.creditBalance,
    };
