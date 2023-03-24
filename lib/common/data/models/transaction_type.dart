enum TransactionType {
  setInitialBalance(true),
  spend(false),
  income(false),
  transfer(false);

  static List<TransactionType> visibleTypes = values.where((element) => !element.isInternal).toList();

  final bool isInternal;

  const TransactionType(this.isInternal);
}