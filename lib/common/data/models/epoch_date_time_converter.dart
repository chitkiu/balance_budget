import 'package:json_annotation/json_annotation.dart';

import '../date_time_extension.dart';

class EpochDateTimeConverter implements JsonConverter<DateTime, int> {
  const EpochDateTimeConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json, isUtc: true).toLocal();

  @override
  int toJson(DateTime object) => object.toUtc().millisecondsSinceEpoch;
}

class EpochWithoutTimeDateTimeConverter extends EpochDateTimeConverter {
  const EpochWithoutTimeDateTimeConverter();

  @override
  DateTime fromJson(int json) => super.fromJson(json).withoutTime;

  @override
  int toJson(DateTime object) => super.toJson(object.withoutTime);
}
