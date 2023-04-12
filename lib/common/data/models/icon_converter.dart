import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:json_annotation/json_annotation.dart';

class IconConverter implements JsonConverter<IconData, String?> {

  const IconConverter();

  @override
  IconData fromJson(String? data) {
    if (data != null) {
      final jsonData = json.decode(data);
      if (jsonData != null) {
        return deserializeIcon(jsonData) ?? Icons.not_interested;
      }
    }
    return Icons.not_interested;
  }

  @override
  String? toJson(IconData object) {
    final serializedIcon = serializeIcon(object);
    if (serializedIcon != null) {
      return json.encode(serializedIcon);
    }
    return null;
  }

}