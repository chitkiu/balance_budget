class CategoryId {
  final String id;

  CategoryId(this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryId && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}