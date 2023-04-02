import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';

import '../../../common/data/date_time_extension.dart';
import '../../../common/data/models/transaction_type.dart';
import 'models/transaction.dart';

class LocalTransactionsRepository {
  CollectionReference<Transaction> get _ref => FirebaseFirestore.instance
      .collection("users/${FirebaseAuth.instance.currentUser!.uid}/transactions")
      .withConverter<Transaction>(
        fromFirestore: (snapshot, _) =>
            Transaction.fromJson(MapEntry(snapshot.id, snapshot.data()!)),
        toFirestore: (category, _) => category.toJson(),
      );

  Stream<List<Transaction>> get transactions =>
      _ref.snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  Stream<Transaction?> getTransactionById(String id) {
    return _ref.doc(id).snapshots().map((event) => event.data());
  }

  Stream<List<Transaction>> getTransactionByTimeRange(
    DateTime start,
    DateTime end,
  ) {
    return _ref
        .where(
          'time',
          isGreaterThanOrEqualTo: start.withoutTime.millisecondsSinceEpoch,
          isLessThanOrEqualTo: end.withoutTime.millisecondsSinceEpoch,
        )
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  bool create(
    double sum,
    TransactionType transactionType,
    String walletId,
    DateTime time, {
    bool skipZeroSum = true,
    String? toWalletId,
    String? categoryId,
    String? comment,
  }) {
    if (skipZeroSum && sum <= 0) {
      return false;
    }

    switch (transactionType) {
      case TransactionType.setInitialBalance:
        _ref.add(SetBalanceTransaction(
          sum: sum,
          transactionType: transactionType,
          walletId: walletId,
          time: time.withoutTime,
          creationTime: DateTime.now(),
        ));
        break;
      case TransactionType.expense:
      case TransactionType.income:
        if (categoryId == null) {
          return false;
        }
        _ref.add(CommonTransaction(
          sum: sum,
          transactionType: transactionType,
          categoryId: categoryId,
          walletId: walletId,
          time: time.withoutTime,
          creationTime: DateTime.now(),
          comment: comment,
        ));
        break;
      case TransactionType.transfer:
        if (toWalletId == null) {
          return false;
        }
        _ref.add(TransferTransaction(
          sum: sum,
          transactionType: transactionType,
          walletId: walletId,
          time: time.withoutTime,
          creationTime: DateTime.now(),
          comment: comment,
          toWalletId: toWalletId,
        ));
        break;
    }

    return true;
  }

  Future<void> remove(String transactionId) async {
    await _ref.doc(transactionId).delete();
  }

  Future<void> edit(
    String transactionId, {
    double? sum,
    TransactionType? transactionType,
    String? categoryId,
    String? walletId,
    DateTime? time,
    String? comment,
  }) async {
    var data = _ref.doc(transactionId);

    var dbTransaction = await data.get();

    if (dbTransaction.exists) {
      var transaction = dbTransaction.data()!;

      Transaction? newTransaction;

      if (transaction is TransferTransaction) {
        newTransaction = transaction.copyWith(
            sum: sum,
            transactionType: transactionType,
            categoryId: categoryId,
            walletId: walletId,
            time: time,
            comment: comment);
      } else if (transaction is CommonTransaction) {
        newTransaction = transaction.copyWith(
            sum: sum,
            transactionType: transactionType,
            categoryId: categoryId,
            walletId: walletId,
            time: time,
            comment: comment);
      }

      if (newTransaction != null && newTransaction != transaction) {
        data.set(newTransaction);
      }
    }
  }
}
