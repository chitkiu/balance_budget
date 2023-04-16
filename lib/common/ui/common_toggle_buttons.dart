import 'dart:math';

import 'package:flutter/material.dart';

class CommonToggleButtons extends StatelessWidget {
  final void Function(int index) onItemClick;
  final List<bool> isSelected;
  final List<Widget> children;
  final Color fillColor;

  final Color? selectedBorderColor;
  final Color? borderColor;
  final Color? selectedColor;
  final Color? color;

  const CommonToggleButtons({super.key,
    required this.onItemClick,
    required this.isSelected,
    required this.fillColor,
    this.selectedBorderColor,
    this.borderColor,
    this.selectedColor,
    this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext, constraints) {
      return ToggleButtons(
        onPressed: onItemClick,
        isSelected: isSelected,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: selectedBorderColor ?? Colors.grey,
        borderColor: borderColor ?? Colors.grey,
        selectedColor: selectedColor ?? Colors.white,
        fillColor: fillColor,
        color: color ?? Colors.black,
        constraints: BoxConstraints(
          minHeight: 40.0,
          minWidth: (constraints.maxWidth - 8 * 2) / max(children.length, isSelected.length),
        ),
        children: children,
      );
    });
  }
}
