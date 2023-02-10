import 'package:get/get.dart';

import '../../common/data/local_account_repository.dart';
import '../ui/models/account_type.dart';

class AddAccountController extends GetxController {
  LocalAccountRepository get _accountRepo => Get.find();

  Rx<AccountType> accountType = AccountType.debit.obs;

  //TODO Add error, split to methods
  void onSaveAccount(
      {required String title,
      String? totalBalance,
      String? ownBalance,
      String? creditBalance}) {
    switch (accountType.value) {
      case AccountType.debit:
        if (totalBalance != null) {
          if (double.tryParse(totalBalance) == null) {
            return;
          }
          _accountRepo.createDebit(title, double.parse(totalBalance));
        }
        break;
      case AccountType.credit:
        if (ownBalance != null && creditBalance != null) {
          if (double.tryParse(ownBalance) == null) {
            return;
          }
          if (double.tryParse(creditBalance) == null) {
            return;
          }
          _accountRepo.createCredit(
              title,
              double.parse(ownBalance),
              double.parse(creditBalance),
          );
        }
        break;
    }

    Get.back();
  }
}
