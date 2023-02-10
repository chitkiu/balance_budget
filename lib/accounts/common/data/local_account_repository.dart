import 'package:balance_budget/accounts/common/data/models/account.dart';
import 'package:balance_budget/accounts/common/data/models/account_id.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class LocalAccountRepository {
  Uuid get _uuid => Get.find();

  final RxList<Account> accounts = <Account>[].obs;

  //TODO Remove after add normal storage
  LocalAccountRepository() {
    createDebit("Mono white", 1000);
    createCredit("Mono black", 0, 1000);
  }

  void createDebit(String name, double totalBalance) {
    accounts.add(DebitAccount(
      id: AccountId(_uuid.v4()),
      name: name,
      totalBalance: totalBalance,
    ));
  }

  void createCredit(String name, double ownBalance, double creditBalance) {
    accounts.add(CreditAccount(
      id: AccountId(_uuid.v4()),
      name: name,
      ownBalance: ownBalance,
      creditBalance: creditBalance,
    ));
  }

  Account? getAccountById(AccountId id) {
    return accounts.firstWhereOrNull((element) => element.id == id);
  }

  void remove(AccountId category) {
    accounts.removeWhere((element) => element.id == category);
  }

  void edit(AccountId id,
      {String? name, double? totalBalance, double? ownBalance, double? creditBalance}) {

    var editAccount = accounts.firstWhereOrNull((element) => element.id == id);
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

    accounts.insert(index, newAccount!);
  }
}
