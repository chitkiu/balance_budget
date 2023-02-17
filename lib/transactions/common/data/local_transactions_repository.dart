import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' hide Transaction;

import '../../../common/data/models/transaction_type.dart';
import 'models/transaction.dart';

class LocalTransactionsRepository {
  DatabaseReference get _ref => FirebaseDatabase.instance
      .ref("users/${FirebaseAuth.instance.currentUser?.uid ?? '0'}/transactions");

  Stream<List<Transaction>> get transactions => _ref.onValue.map((event) {
        if (event.snapshot.exists) {
          Map<String, dynamic> dataValue = jsonDecode(jsonEncode(event.snapshot.value));
          return dataValue.entries.map((e) => Transaction.fromJson(e)).toList();
        } else {
          return <Transaction>[];
        }
      });

  Stream<Transaction?> getTransactionById(String id) {
    return _ref.child(id).onValue.map((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> dataValue = jsonDecode(jsonEncode(event.snapshot.value));
        return Transaction.fromJson(dataValue.entries.first);
      }
      return null;
    });
  }

  bool create(double sum, TransactionType transactionType, String? categoryId,
      String accountId, DateTime time, String? comment, {bool skipZeroSum = true}) {
    if (skipZeroSum && sum <= 0) {
      return false;
    }
    var newTransaction = _ref.push();
    newTransaction.set(Transaction(
      sum: sum,
      transactionType: transactionType,
      categoryId: categoryId,
      accountId: accountId,
      time: time,
      creationTime: DateTime.now(),
      comment: comment,
    ).toJson());

    return true;
  }

  Future<void> remove(String transactionId) async {
    var localRef = _ref.child(transactionId);
    await localRef.remove();
  }

  Future<void> edit(String transactionId,
      {double? sum, String? categoryId, DateTime? time, String? comment}) async {
    var data = _ref.child(transactionId);

    var dbTransaction = await data.get();

    if (dbTransaction.exists) {
      var transaction = Transaction.fromJson(
          MapEntry(transactionId, jsonDecode(jsonEncode(dbTransaction.value))));

      var newTransaction = transaction
          .copyWith(sum: sum, categoryId: categoryId, time: time, comment: comment);

      if (newTransaction != transaction) {
        data.set(newTransaction.toJson());
      }
    }
  }
}
