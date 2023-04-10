import 'models/rich_transaction_model.dart';

class RichTransactionComparator {
  const RichTransactionComparator();

  int compare(RichTransactionModel a, RichTransactionModel b) {
    var result = b.transaction.time.compareTo(a.transaction.time);
    if (result == 0) {
      return b.transaction.creationTime.compareTo(a.transaction.creationTime);
    }
    return result;
  }
}
