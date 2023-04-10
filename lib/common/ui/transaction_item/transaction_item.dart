import 'package:flutter/material.dart';

import '../../../../common/ui/common_icons.dart';
import '../common_tile.dart';
import 'models/transaction_ui_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionUIModel transaction;
  final void Function(TransactionUIModel transaction) onItemClick;

  const TransactionItem(this.transaction, this.onItemClick, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onItemClick(transaction),
      child: CommonTile(
        icon: Icons.no_transfer,
        textWidget: Text(transaction.categoryName,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        secondTextWidget: _subtitle(transaction),
        additionalTextWidget:
            _additionalInfo(transaction.comment, CommonIcons.note),
        tailing: Text(transaction.sum,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: transaction.sumColor)),
      ),
    );
  }

  Widget _subtitle(TransactionUIModel model) {
    String subtitleText;
    if (model is TransferTransactionUIModel) {
      subtitleText = "${model.fromWalletName} => ${model.toWalletName}";
    } else {
      subtitleText = model.walletName;
    }

    return _additionalInfo(subtitleText, CommonIcons.wallet)!;
  }

  Widget? _additionalInfo(String? text, IconData icon) {
    if (text == null) return null;
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }
}
