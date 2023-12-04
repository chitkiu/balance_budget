import 'package:balance_budget/common/getx_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_bloc_scaffold_with_button_screen.dart';
import '../../../common/ui/common_tile.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../common/ui/transaction_item/transaction_section_header_widget.dart';
import '../../common/data/local_category_repository.dart';
import '../domain/category_info_bloc.dart';
import '../domain/category_info_event.dart';
import '../domain/category_info_status.dart';
import 'models/rich_category_ui_model.dart';

class CategoryInfoScreen extends StatelessWidget {
  final String id;
  const CategoryInfoScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryInfoBloc>(
      create: (context) => CategoryInfoBloc(
        context.read<LocalCategoryRepository>(),
      )..add(LoadCategoryEvent(id)),
      child: _CategoryInfoView(),
    );
  }
}

class _CategoryInfoView extends CommonBlocScaffoldWithButtonScreen {

  _CategoryInfoView(): super(Get.localisation.category_info_title);

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<CategoryInfoBloc, CategoryInfoState>(
      builder: (context, state) {
        final category = state.model;
        switch (state.status) {
          case CategoryInfoStatus.initial:
            return const SizedBox.shrink();
          case CategoryInfoStatus.loading:
            return Center(
              child: PlatformCircularProgressIndicator(),
            );
          case CategoryInfoStatus.success:
            if (category != null) {
              return _categoryInfo(category, context);
            } else {
              //TODO make correct error
              return Center(
                child: Text(state.error ?? ""),
              );
            }
          case CategoryInfoStatus.failure:
            return Center(
              child: Text("Error:\n${state.error}"),
            );
        }
      },
    );
  }

  Widget _categoryInfo(
      RichCategoryUIModel model,
      BuildContext context,
      ) {
    final category = model.category;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: CommonUI.defaultTileHorizontalPadding),
      child: Column(
        children: [
          const SizedBox(
            height: CommonUI.defaultTileVerticalPadding,
          ),
          CommonTile(
            text: Get.localisation.category_name_title,
            secondText: category.name,
            icon: category.icon,
          ),
          const SizedBox(
            height: CommonUI.defaultFullTileVerticalPadding,
          ),
          PlatformElevatedButton(
            onPressed: () async {
              await confirmBeforeActionDialog(
                    () async {
                      context.read<CategoryInfoBloc>().add(
                        ChangeArchiveStatusOnCategoryEvent(model.category.id)
                      );
                },
              );
            },
            child: Text(category.isArchived
                ? Get.localisation.unarchive
                : Get.localisation.archive),
          ),
          if (category.isArchived)
            PlatformElevatedButton(
              onPressed: () async {
                await confirmBeforeActionDialog(
                      () async {
                    try {
                      context.read<CategoryInfoBloc>().add(
                          DeleteCategoryEvent(model.category.id)
                      );
                      Get.back();
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  title: Get.localisation.confirmToDeleteTitle,
                  subTitle: Get.localisation.confirmToDeleteText,
                  confirmAction: Get.localisation.yes,
                  cancelAction: Get.localisation.no,
                );
              },
              child: Text(Get.localisation.delete),
            ),
          const SizedBox(
            height: CommonUI.defaultFullTileVerticalPadding,
          ),
          if (model.transactions.transactions.isNotEmpty)
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                Get.localisation.transaction_list_subtitle,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (model.transactions.transactions.isNotEmpty)
            const SizedBox(
              height: 8,
            ),
          if (model.transactions.transactions.isNotEmpty)
            Expanded(
                child: ListView.builder(
                  itemCount: model.transactions.transactions.length,
                  itemBuilder: (context, index) {
                    final item = model.transactions.transactions[index];
                    return TransactionSectionHeaderWidget(
                      model: item,
                      onItemClick: (transaction) {
                        context.read<CategoryInfoBloc>().add(
                            TransactionClickInCategoryEvent(transaction)
                        );
                      },
                      itemPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: CommonUI.defaultTileVerticalPadding),
                      titlePadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    );
                  },
                )),
          if (model.transactions.transactions.isEmpty)
            Expanded(
                child: Center(
                  child: Text(Get.localisation.noTransactions),
                ))
        ],
      ),
    );
  }
}
