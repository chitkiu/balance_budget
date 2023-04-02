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

  Stream<Transaction?> getTransactionById(
      String id,
      ) {
    return _ref.doc(id)
        .snapshots()
        .map((event) {
      if (event.exists) {
        return event.data();
      } else {
        return null;
      }
    });
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

  bool createOrUpdate(
    double sum,
    TransactionType transactionType,
    String walletId,
    DateTime time, {
    bool skipZeroSum = true,
    String? toWalletId,
    String? categoryId,
    String? comment,
        String? id,
  }) {
    if (skipZeroSum && sum <= 0) {
      return false;
    }
    Transaction transaction;
    switch (transactionType) {
      case TransactionType.setInitialBalance:
        transaction = SetBalanceTransaction(
          sum: sum,
          transactionType: transactionType,
          walletId: walletId,
          time: time.withoutTime,
          creationTime: DateTime.now(),
        );
        break;
      case TransactionType.expense:
      case TransactionType.income:
        if (categoryId == null) {
          return false;
        }
        transaction = CommonTransaction(
          sum: sum,
          transactionType: transactionType,
          categoryId: categoryId,
          walletId: walletId,
          time: time.withoutTime,
          creationTime: DateTime.now(),
          comment: comment,
        );
        break;
      case TransactionType.transfer:
        if (toWalletId == null) {
          return false;
        }
        transaction = TransferTransaction(
          sum: sum,
          transactionType: transactionType,
          walletId: walletId,
          time: time.withoutTime,
          creationTime: DateTime.now(),
          comment: comment,
          toWalletId: toWalletId,
        );
        break;
    }

    if (id != null) {
      _ref.doc(id).set(transaction);
    } else {
      _ref.add(transaction);
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
