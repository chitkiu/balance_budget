import 'package:flutter/material.dart';

class SelectorDialogTheme {
  final String? font;
  final Color? selectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? backgroundColor;

  const SelectorDialogTheme({
    this.font = '',
    this.selectedBackgroundColor = const Color(0xff3AC3E2),
    this.selectedTextColor = Colors.white,
    this.backgroundColor = Colors.white,
  });
}