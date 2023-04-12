import 'package:balance_budget/common/getx_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_tile.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../common/ui/transaction_item/transaction_section_header_widget.dart';
import '../domain/category_info_controller.dart';

class CategoryInfoScreen extends CommonScaffoldWithButtonScreen<CategoryInfoController> {
  CategoryInfoScreen({super.key})
      : super(Get.localisation.category_info_title, icon: CommonIcons.edit);

  @override
  Widget body(BuildContext context) {
    return controller.obx(
      (state) {
        if (state == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final category = state.category;
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
              if (state.transactions.transactions.isNotEmpty)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    Get.localisation.transaction_list_subtitle,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              if (state.transactions.transactions.isNotEmpty)
                const SizedBox(
                  height: 8,
                ),
              if (state.transactions.transactions.isNotEmpty)
                Expanded(
                    child: ListView.builder(
                  itemCount: state.transactions.transactions.length,
                  itemBuilder: (context, index) {
                    final model = state.transactions.transactions[index];
                    return TransactionSectionHeaderWidget(
                      model: model,
                      onItemClick: (transaction) {},
                      itemPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: CommonUI.defaultTileVerticalPadding),
                      titlePadding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    );
                  },
                )),
              if (state.transactions.transactions.isEmpty)
                Expanded(child: Center(child: Text(Get.localisation.noTransactions),))
            ],
          ),
        );
      },
    );
  }

  @override
  void onButtonPress() {
    // TODO: implement onButtonPress
  }
}
