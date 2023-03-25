import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../../common/ui/common_icons.dart';
import '../models/transaction_ui_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionUIModel transaction;
  final void Function(TransactionUIModel transaction) onItemClick;

  const TransactionItem(this.transaction, this.onItemClick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onItemClick(transaction),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kDebugMode)
                Text("ID: ${transaction.id}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(transaction.categoryName,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text(transaction.sum,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: transaction.sumColor)),
                ],
              ),
              if (transaction is TransferTransactionUIModel)
                _additionalInfo("${(transaction as TransferTransactionUIModel).toAccountName} => ${(transaction as TransferTransactionUIModel).fromAccountName}", CommonIcons.wallet),
              if (transaction is !TransferTransactionUIModel)
                _additionalInfo(transaction.accountName, CommonIcons.wallet),
              if (transaction.comment != null)
                _additionalInfo(transaction.comment!, CommonIcons.note),
            ],
          ),
        )
    );
  }

  Widget _additionalInfo(String text, IconData icon) {
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
