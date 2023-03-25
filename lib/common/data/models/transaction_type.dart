enum TransactionType {
  setInitialBalance,
  spend,
  income,
  transfer;

  static List<TransactionType> showInTransactionList = [
    TransactionType.spend,
    TransactionType.income,
    TransactionType.transfer,
  ];

  static List<TransactionType> canAddCategory = [
    TransactionType.spend,
    TransactionType.income,
  ];

  const TransactionType();
}