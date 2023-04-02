enum TransactionType {
  setInitialBalance,
  expense,
  income,
  transfer;

  static List<TransactionType> showInTransactionList = [
    TransactionType.expense,
    TransactionType.income,
    TransactionType.transfer,
  ];

  static List<TransactionType> canAddCategory = [
    TransactionType.expense,
    TransactionType.income,
  ];

  const TransactionType();
}