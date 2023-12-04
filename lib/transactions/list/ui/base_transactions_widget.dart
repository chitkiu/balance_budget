import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/ui/transaction_item/models/transaction_header_ui_model.dart';
import '../../../common/ui/transaction_item/transaction_section_header_widget.dart';
import '../domain/transactions_cubit.dart';

abstract class BaseTransactionsWidget extends StatelessWidget {

  const BaseTransactionsWidget({super.key});

  @protected
  Widget transactionWidget(BuildContext context, TransactionHeaderUIModel item) {
    return TransactionSectionHeaderWidget(
      model: item,
      onItemClick: (transaction) {
        context.read<TransactionsCubit>().onItemClick(context, transaction);
      },
    );
  }
}
