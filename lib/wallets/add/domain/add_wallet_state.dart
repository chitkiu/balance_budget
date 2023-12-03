import '../ui/models/wallet_type.dart';

class AddWalletState {
  final String? name;
  final WalletType walletType;
  final String? totalBalance;
  final String? ownBalance;
  final String? creditBalance;
  final String? error;

  AddWalletState(
      {required this.name,
      required this.walletType,
      required this.totalBalance,
      required this.ownBalance,
      required this.creditBalance,
      this.error});

  AddWalletState copyWith(
      {String? name,
      WalletType? walletType,
      String? totalBalance,
      String? ownBalance,
      String? creditBalance,
      String? error,}) {
    return AddWalletState(
      name: name ?? this.name,
      walletType: walletType ?? this.walletType,
      totalBalance: totalBalance ?? this.totalBalance,
      ownBalance: ownBalance ?? this.ownBalance,
      creditBalance: creditBalance ?? this.creditBalance,
      error: error ?? this.error,
    );
  }
}
