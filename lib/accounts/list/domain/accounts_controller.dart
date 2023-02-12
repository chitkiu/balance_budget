import 'dart:async';

import 'package:get/get.dart';

import '../../add/domain/add_account_binding.dart';
import '../../add/ui/add_account_screen.dart';
import '../../common/data/local_account_repository.dart';
import '../ui/models/account_ui_model.dart';
import 'mappers/account_ui_mapper.dart';

class AccountsController extends GetxController {
  LocalAccountRepository get _accountRepo => Get.find();

  final AccountUIMapper _mapper = AccountUIMapper();

  RxList<AccountUIModel> accounts = <AccountUIModel>[].obs;
  StreamSubscription? _listener;

  @override
  void onReady() {
    _listener?.cancel();
    _listener = _accountRepo.accounts.listen((event) {
      accounts.value = event.map(_mapper.map).toList();
    });

    super.onReady();
  }

  @override
  void onClose() {
    _listener?.cancel();
    _listener = null;
    super.onClose();
  }

  void onAddClick() {
    Get.to(
          () => AddAccountScreen(),
      binding: AddAccountBinding(),
    );
  }
}