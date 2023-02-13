enum TransactionType {
  setInitialBalance(true),
  spend(false),
  income(false);

  static Iterable<TransactionType> visibleTypes = values.where((element) => !element.isInternal);

  final bool isInternal;

  const TransactionType(this.isInternal);
}