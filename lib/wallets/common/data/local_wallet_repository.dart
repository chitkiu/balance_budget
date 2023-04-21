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

  Stream<List<Wallet>> get walletsWithoutArchived =>
      _ref.where("archived", isEqualTo: false)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());

  //TODO Added creating default accounts (cash for example)
  LocalWalletRepository() {
    // createDebit("Mono white", 1000);
    // createCredit("Mono black", 0, 1000);
  }

  Future<void> createDebit(String name, double totalBalance) async {
    var newWallet = await _ref.add(DebitWallet(
      name: name,
      archived: false,
    ));

    _createInitialTransaction(newWallet.id, totalBalance);
  }

  Future<void> createCredit(
      String name, double ownBalance, double creditBalance) async {
    var newWallet = await _ref.add(CreditWallet(
      name: name,
      creditBalance: creditBalance,
      archived: false,
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

  Future<Wallet?> getWalletById(String id) async {
    return (await _ref.doc(id).get()).data();
  }

  void remove(String walletId) {
    // accounts.removeWhere((element) => element.id == category);
  }

  Future<void> edit(String id,
      {String? name,
      double? creditBalance,
      bool? archived}) async {
    final data = _ref.doc(id);

    final editWallet = (await data.get()).data();

    if (editWallet == null) {
      return;
    }

    Wallet? newWallet;

    if (editWallet is DebitWallet) {
      newWallet = editWallet.copyWith(
        name: name,
        archived: archived,
      );
    } else if (editWallet is CreditWallet) {
      newWallet = editWallet.copyWith(
        name: name,
        creditBalance: creditBalance,
        archived: archived,
      );
    }

    if (newWallet != null) {
      await data.set(newWallet);
    }
  }

  void _createInitialTransaction(String? walletId, double sum) {
    _transactionRepo.createOrUpdate(
        sum, TransactionType.setInitialBalance, walletId ?? '', DateTime.now(),
        skipZeroSum: false);
  }
}
