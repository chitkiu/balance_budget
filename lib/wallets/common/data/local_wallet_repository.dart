import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../transactions/common/data/local_transactions_repository.dart';
import 'models/wallet.dart';

class LocalWalletRepository {
  CollectionReference<Wallet> get _ref => FirebaseFirestore.instance
      .collection("users/${FirebaseAuth.instance.currentUser!.uid}/wallets")
      .withConverter<Wallet>(
        fromFirestore: (snapshot, _) =>
            Wallet.fromJson(MapEntry(snapshot.id, snapshot.data()!)),
        toFirestore: (wallet, _) => wallet.toJson(),
      );

  LocalTransactionsRepository get _transactionRepo => Get.find();

  Stream<List<Wallet>> get wallets =>
      _ref.snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  //TODO Added creating default accounts (cash for example)
  LocalWalletRepository() {
    // createDebit("Mono white", 1000);
    // createCredit("Mono black", 0, 1000);
  }

  Future<void> createDebit(String name, double totalBalance) async {
    var newWallet = await _ref.add(DebitWallet(
      name: name,
    ));

    _createInitialTransaction(newWallet.id, totalBalance);
  }

  Future<void> createCredit(
      String name, double ownBalance, double creditBalance) async {
    var newWallet = await _ref.add(CreditWallet(
      name: name,
      creditBalance: creditBalance,
    ));

    _createInitialTransaction(newWallet.id, ownBalance);
  }

  Stream<Wallet?> walletById(String id) {
    return _ref.doc(id).snapshots().map((event) {
      if (event.exists) {
        return event.data();
      } else {
        return null;
      }
    });
  }

  void remove(String walletId) {
    // accounts.removeWhere((element) => element.id == category);
  }

  void edit(String id,
      {String? name,
      double? totalBalance,
      double? ownBalance,
      double? creditBalance}) {
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

  void _createInitialTransaction(String? walletId, double sum) {
    _transactionRepo.createOrUpdate(
        sum, TransactionType.setInitialBalance, walletId ?? '', DateTime.now(),
        skipZeroSum: false);
  }
}
