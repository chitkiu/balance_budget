import '../../../common/ui/transaction_item/models/transaction_ui_model.dart';
import '../../common/data/models/rich_transaction_model.dart';

class TransactionInfoState {
  final RichTransactionModel? dataModel;
  final TransactionUIModel? model;
  final bool canEdit;

  TransactionInfoState(this.dataModel, this.model, this.canEdit);
}