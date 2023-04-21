import 'package:flutter/widgets.dart';

class CategoryUIModel {
  final String name;
  final String id;
  final IconData icon;
  final bool isArchived;

  CategoryUIModel(this.name, this.id, this.icon, this.isArchived);
}