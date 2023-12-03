import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../domain/selected_transactions_date_storage.dart';
import '../domain/transactions_cubit.dart';
import 'cupertino_transactions_widget.dart';
import 'material_transactions_widget.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TransactionsCubit(
          context.read<SelectedTransactionsDateStorage>(),
        ),
      child: PlatformWidgetBuilder(
        cupertino: (context, child, target) => CupertinoTransactionsWidget(),
        material: (context, child, target) => MaterialTransactionsWidget(),
      ),
    );
  }
}
