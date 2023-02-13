class TransactionUIModel {
  final String id;
  final String sum;
  final String categoryName;
  final String accountName;
  final String time;
  final String? comment;

  TransactionUIModel(
      {required this.id,
      required this.sum,
      required this.categoryName,
      required this.accountName,
      required this.time,
      this.comment});
}
