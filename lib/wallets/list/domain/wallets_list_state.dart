import '../ui/models/wallet_ui_model.dart';

enum WalletsListStatus { initial, loading, success, failure }

class WalletsListState {
  final WalletsListStatus status;
  final List<WalletUIModel> items;
  final String? error;

  WalletsListState(this.status, this.items, this.error);

  WalletsListState copyWith({WalletsListStatus? status, List<WalletUIModel>? items, String? error}) {
    return WalletsListState(
        status ?? this.status,
        items ?? this.items,
        error ?? this.error,
    );
  }
}
