import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/data/date_time_extension.dart';
import '../../../common/data/models/transaction_type.dart';
import 'models/rich_transaction_model.dart';
import 'models/transaction.dart';

class LocalTransactionsRepository {
  CollectionReference get collection => FirebaseFirestore.instance
      .collection("users/${FirebaseAuth.instance.currentUser!.uid}/transactions");

  CollectionReference<Transaction> get _ref => collection
      .withConverter<Transaction>(
        fromFirestore: (snapshot, _) =>
            Transaction.fromJson(MapEntry(snapshot.id, snapshot.data()!)),
        toFirestore: (category, _) => category.toJson(),
      );

  Stream<List<Transaction>> get transactions =>
      _ref.snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  Future<void> removeAll() async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<Transaction?> transactionById(
    String id,
  ) {
    return _ref.doc(id).snapshots().map((event) {
      if (event.exists) {
        return event.data();
      } else {
        return null;
      }
    });
  }

  Stream<List<Transaction>> transactionByTimeRange(
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

  Stream<List<Transaction>> transactionsByWalletId(
    String walletId,
  ) {
    final transactionsFromWallet = _ref
        .where('walletId', isEqualTo: walletId)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());

    final transferTransactionsFromWallet = _ref
        .where('toWalletId', isEqualTo: walletId)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());

    return CombineLatestStream.combine2(transactionsFromWallet,
        transferTransactionsFromWallet, (a, b) => a + b);
  }

  Future<List<Transaction>> getTransactionsByWalletId(
    String walletId,
  ) async {
    final transactionsFromWallet = (await _ref
        .where('walletId', isEqualTo: walletId)
        .get())
        .docs.map((event) => event.data()).toList();

    final transferTransactionsFromWallet = (await _ref
        .where('toWalletId', isEqualTo: walletId)
        .get())
        .docs.map((event) => event.data()).toList();

    return transactionsFromWallet + transferTransactionsFromWallet;
  }

  Stream<List<Transaction>> transactionsByCategoryId(
    String categoryId,
  ) {
    return _ref
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<List<Transaction>> getTransactionsByCategoryId(
    String categoryId,
  ) async {
    final items = await _ref
      .where('categoryId', isEqualTo: categoryId)
      .get();

    return items.docs.map((event) => event.data()).toList();
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
    RichTransactionModel? model,
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
          creationTime: model?.transaction.creationTime ?? DateTime.now(),
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
          creationTime: model?.transaction.creationTime ?? DateTime.now(),
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
          creationTime: model?.transaction.creationTime ?? DateTime.now(),
          comment: comment,
          toWalletId: toWalletId,
        );
        break;
    }

    if (model != null) {
      _ref.doc(model.transaction.id).set(transaction);
    } else {
      _ref.add(transaction);
    }

    return true;
  }

  Future<void> remove(String transactionId) async {
    await _ref.doc(transactionId).delete();
  }

  Future<void> bunchDelete(List<String> ids) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      for (var id in ids) {
        transaction.delete(_ref.doc(id));
      }
    });
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
