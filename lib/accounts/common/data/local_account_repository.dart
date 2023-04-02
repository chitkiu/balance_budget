import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../transactions/common/data/local_transactions_repository.dart';
import 'models/account.dart';

class LocalAccountRepository {
  CollectionReference<Account> get _ref =>
      FirebaseFirestore.instance.collection("users/${FirebaseAuth.instance.currentUser!.uid}/wallets").withConverter<Account>(
            fromFirestore: (snapshot, _) =>
                Account.fromJson(MapEntry(snapshot.id, snapshot.data()!)),
            toFirestore: (account, _) => account.toJson(),
          );

  LocalTransactionsRepository get _transactionRepo => Get.find();

  Stream<List<Account>> get accounts =>
      _ref.snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  //TODO Added creating default accounts (cash for example)
  LocalAccountRepository() {
    // createDebit("Mono white", 1000);
    // createCredit("Mono black", 0, 1000);
  }

  Future<void> createDebit(String name, double totalBalance) async {
    var newAccount = await _ref.add(DebitAccount(
      name: name,
    ));

    _createInitialTransaction(newAccount.id, totalBalance);
  }

  Future<void> createCredit(String name, double ownBalance, double creditBalance) async {
    var newAccount = await _ref.add(CreditAccount(
      name: name,
      creditBalance: creditBalance,
    ));

    _createInitialTransaction(newAccount.id, ownBalance);
  }

  Account? getAccountById(String id) {
    // return accounts.firstWhereOrNull((element) => element.id == id);
  }

  void remove(String account) {
    // accounts.removeWhere((element) => element.id == category);
  }

  void edit(String id,
      {String? name, double? totalBalance, double? ownBalance, double? creditBalance}) {
/*    var editAccount = accounts.firstWhereOrNull((element) => element.id == id);
    if (editAccount == null) {
      return;
    }

    var index = accounts.lastIndexOf(editAccount);

    accounts.removeAt(index);

    Account? newAccount;

    if (editAccount is DebitAccount) {
      newAccount = editAccount.copyWith(
        name: name,
        totalBalance: totalBalance,
      );
    } else if (editAccount is CreditAccount) {
      newAccount = editAccount.copyWith(
        name: name,
        ownBalance: ownBalance,
        creditBalance: creditBalance,
      );
    }

    accounts.insert(index, newAccount!);*/
  }

  void _createInitialTransaction(String? accountId, double sum) {
    _transactionRepo.create(sum, TransactionType.setInitialBalance, accountId ?? '',
        DateTime.now(),
        skipZeroSum: false);
  }
}
