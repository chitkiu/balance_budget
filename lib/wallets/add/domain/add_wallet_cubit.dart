import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../common/data/local_wallet_repository.dart';
import '../ui/models/wallet_type.dart';
import 'add_wallet_state.dart';

class AddWalletCubit extends Cubit<AddWalletState> {
  final LocalWalletRepository _walletRepo;

  AddWalletCubit(this._walletRepo)
      : super(AddWalletState(
      name: null,
      walletType: WalletType.debit,
      totalBalance: "0",
      ownBalance: "0",
      creditBalance: "0"));

  void changeWalletType(WalletType newType) {
    emit(state.copyWith(
      walletType: newType,
    ));
  }

  void changeName(String newName) {
    emit(state.copyWith(
      name: newName,
      error: null,
    ));
  }

  void changeTotalBalance(String newBalance) {
    emit(state.copyWith(
      totalBalance: newBalance,
      error: null,
    ));
  }

  void changeOwnBalance(String newBalance) {
    emit(state.copyWith(
      ownBalance: newBalance,
      error: null,
    ));
  }

  void changeCreditBalance(String newBalance) {
    emit(state.copyWith(
      creditBalance: newBalance,
      error: null,
    ));
  }

  Future<void> onSaveWallet() async {
    if (state.name == null) {
      emit(state.copyWith(
        error: "Enter name, please",
      ));
      return;
    }
    bool isSuccess;
    switch (state.walletType) {
      case WalletType.debit:
        isSuccess = await _saveDebit();
        break;
      case WalletType.credit:
        isSuccess = await _saveCredit();
        break;
    }

    if (isSuccess) {
      Get.back();
    }
  }

  Future<bool> _saveDebit() async {
    final totalBalance = _formatNumber(state.totalBalance);

    if (totalBalance == null) {
      emit(state.copyWith(
        error: "Enter total balance, please",
      ));
      return false;
    }
    if (double.tryParse(totalBalance) == null) {
      emit(state.copyWith(
        error: "Please, enter valid number as total balance",
      ));
      return false;
    }

    await _walletRepo.createDebit(state.name!, double.parse(totalBalance));
    return true;
  }

  Future<bool> _saveCredit() async {
    final ownBalance = _formatNumber(state.ownBalance);
    final creditBalance = _formatNumber(state.creditBalance);

    if (ownBalance == null) {
      emit(state.copyWith(
        error: "Enter own balance, please",
      ));
      return false;
    }
    if (creditBalance == null) {
      emit(state.copyWith(
        error: "Enter credit balance, please",
      ));
      return false;
    }

    if (double.tryParse(ownBalance) == null) {
      emit(state.copyWith(
        error: "Please, enter valid number as own balance",
      ));
      return false;
    }
    if (double.tryParse(creditBalance) == null) {
      emit(state.copyWith(
        error: "Please, enter valid number as credit balance",
      ));
      return false;
    }

    await _walletRepo.createCredit(
      state.name!,
      double.parse(ownBalance),
      double.parse(creditBalance),
    );

    return true;
  }

  String? _formatNumber(String? number) {
    return number?.replaceAll(",", ".");
  }

}
