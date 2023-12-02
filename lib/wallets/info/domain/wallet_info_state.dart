import '../ui/models/rich_wallet_ui_model.dart';

enum WalletInfoStatus { initial, loading, success, failure }

class WalletInfoState {
  final WalletInfoStatus status;
  final RichWalletUIModel? model;
  final String? error;

  WalletInfoState(this.status, this.model, this.error);

  WalletInfoState copyWith(
      {WalletInfoStatus? status, RichWalletUIModel? model, String? error}) {
    return WalletInfoState(
      status ?? this.status,
      model ?? this.model,
      error ?? this.error,
    );
  }
}
