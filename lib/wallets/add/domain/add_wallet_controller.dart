import 'package:get/get.dart';

import '../../../common/domain/name_validator.dart';
import '../../../common/domain/number_validator.dart';
import '../../common/data/local_wallet_repository.dart';
import '../ui/models/wallet_type.dart';

class AddWalletController extends GetxController with NameValidator, NumberValidator {
  LocalWalletRepository get _walletRepo => Get.find();

  Rx<WalletType> walletType = WalletType.debit.obs;

  //TODO Add error, split to methods
  Future<void> onSaveWallet(
      {required String title,
      String? totalBalance,
      String? ownBalance,
      String? creditBalance}) async {
    switch (walletType.value) {
      case WalletType.debit:
        if (totalBalance != null) {
          if (double.tryParse(totalBalance) == null) {
            return;
          }
          await _walletRepo.createDebit(title, double.parse(totalBalance));
        }
        break;
      case WalletType.credit:
        if (ownBalance != null && creditBalance != null) {
          if (double.tryParse(ownBalance) == null) {
            return;
          }
          if (double.tryParse(creditBalance) == null) {
            return;
          }
          await _walletRepo.createCredit(
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
