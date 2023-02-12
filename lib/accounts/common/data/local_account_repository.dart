import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'models/account.dart';

class LocalAccountRepository {
  DatabaseReference get _ref => FirebaseDatabase.instance.ref("users/${FirebaseAuth.instance.currentUser?.uid ?? '0'}/accounts");

  Stream<List<Account>> get accounts => _ref.onValue.map((event) {
    if (event.snapshot.exists) {
      Map<String, dynamic> dataValue = jsonDecode(jsonEncode(event.snapshot.value));
      return dataValue.entries.map((e) => Account.fromJson(e)).toList();
    } else {
      return <Account>[];
    }
  });

  //TODO Added creating default accounts (cash for example)
  LocalAccountRepository() {
    // createDebit("Mono white", 1000);
    // createCredit("Mono black", 0, 1000);
  }

  void createDebit(String name, double totalBalance) {
    var newAccount = _ref.push();
    newAccount.set(
        DebitAccount(
          name: name,
          totalBalance: totalBalance,
        ).toJson()
    );
    // accounts.add(DebitAccount(
    //   id: AccountId(_uuid.v4()),
    //   name: name,
    //   totalBalance: totalBalance,
    // ));
  }

  void createCredit(String name, double ownBalance, double creditBalance) {
    var newAccount = _ref.push();
    newAccount.set(
        CreditAccount(
          name: name,
          ownBalance: ownBalance,
          creditBalance: creditBalance,
        ).toJson()
    );
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
}
