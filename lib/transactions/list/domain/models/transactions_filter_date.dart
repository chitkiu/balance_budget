class TransactionsFilterDate {
  final DateTime start;
  final DateTime end;

  TransactionsFilterDate({required this.start, required this.end});

  @override
  String toString() {
    return 'TransactionsFilterDate{start: $start, end: $end}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionsFilterDate &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
