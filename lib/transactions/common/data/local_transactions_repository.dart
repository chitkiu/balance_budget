import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' hide Transaction;

import '../../../common/data/models/transaction_type.dart';
import 'models/transaction.dart';

class LocalTransactionsRepository {
  DatabaseReference get _ref => FirebaseDatabase.instance.ref("users/${FirebaseAuth.instance.currentUser?.uid ?? '0'}/transactions");

  Stream<List<Transaction>> get transactions => _ref.onValue.map((event) {
    if (event.snapshot.exists) {
      Map<String, dynamic> dataValue = jsonDecode(jsonEncode(event.snapshot.value));
      return dataValue.entries.map((e) => Transaction.fromJson(e)).toList();
    } else {
      return <Transaction>[];
    }
  });

  void create(double sum, TransactionType transactionType, String categoryId, String accountId, DateTime time, String? comment) {
    var newTransaction = _ref.push();
    newTransaction.set(
        Transaction(
          sum: sum,
          transactionType: transactionType,
          categoryId: categoryId,
          accountId: accountId,
          time: time,
          comment: comment,
        ).toJson()
    );
  }

  Future<void> remove(String transactionId) async {
    var localRef = _ref.child(transactionId);
    await localRef.remove();
  }

  void edit(String transactionId, double? sum, String? categoryId, DateTime? time, String? comment) {
/*
    var editSpend =
        transactions.firstWhereOrNull((element) => element.id == spend);
    if (editSpend == null) {
      return;
    }
    var index = transactions.lastIndexOf(editSpend);

    transactions.removeAt(index);

    transactions.insert(index, editSpend.copyWith(sum: sum, categoryId: categoryId, time: time, comment: comment));
*/
  }
}
