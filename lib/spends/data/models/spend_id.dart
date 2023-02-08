class SpendId {
  final String id;

  SpendId(this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpendId && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return id.toString();
  }
}