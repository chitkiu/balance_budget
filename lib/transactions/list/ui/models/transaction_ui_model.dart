class TransactionUIModel {
  final String id;
  final String sum;
  final String categoryName;
  final String accountName;
  final String time;
  final DateTime dateTime;
  final String? comment;

  const TransactionUIModel(
      {required this.id,
      required this.sum,
      required this.categoryName,
      required this.accountName,
      required this.time,
      required this.dateTime,
      this.comment});
}
