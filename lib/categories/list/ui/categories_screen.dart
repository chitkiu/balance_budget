import 'package:balance_budget/categories/list/ui/models/category_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_bloc_scaffold_with_button_screen.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_tile.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../common/data/local_category_repository.dart';
import '../domain/categories_list_bloc.dart';
import '../domain/categories_list_event.dart';
import '../domain/categories_list_status.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesListBloc(
          Get.find<LocalCategoryRepository>() //TODO Rewrite to BLoC
      )
      ..add(const LoadCategoriesListEvent()),
      child: _CategoriesScreenView(),
    );
  }
}


class _CategoriesScreenView extends CommonBlocScaffoldWithButtonScreen {
  _CategoriesScreenView({Key? key})
      : super(Get.localisation.categoriesTitle, icon: CommonIcons.add, key: key);

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<CategoriesListBloc, CategoriesListState>(
        builder: (context, state) {
          final status = state.status;

          final categories = state.items;

          switch (status) {
            case CategoriesListStatus.initial:
              return const SizedBox.shrink();
            case CategoriesListStatus.loading:
              return Center(
                child: PlatformCircularProgressIndicator(),
              );
            case CategoriesListStatus.success:
              return categoriesItemList(categories);
            case CategoriesListStatus.failure:
              return Center(
                child: Text("Error:\n${state.error}"),
              );
          }
        },
    );
  }

  Widget categoriesItemList(List<CategoryUIModel> categories) {
    if (categories.isEmpty) {
      return Center(
        child: Text(Get.localisation.noCategories),
      );
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            context.read<CategoriesListBloc>()
                .add(CategoryClickEvent(category.id));
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: CommonUI.defaultTileHorizontalPadding),
              child: CommonTile(icon: category.icon, text: category.name)),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: categories.length,
    );
  }

  @override
  void onButtonPress(BuildContext context) {
    context.read<CategoriesListBloc>()
        .add(const AddCategoryEvent());
  }
}

