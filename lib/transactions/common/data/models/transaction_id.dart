class TransactionId {
  final String id;

  TransactionId(this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionId && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return id.toString();
  }
}