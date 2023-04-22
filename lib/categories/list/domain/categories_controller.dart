import 'dart:async';

import 'package:balance_budget/common/data/models/transaction_type.dart';
import 'package:get/get.dart';

import '../../add/domain/add_category_binding.dart';
import '../../add/ui/add_category_screen.dart';
import '../../common/data/local_category_repository.dart';
import '../ui/models/category_ui_model.dart';
import 'mappers/category_ui_mapper.dart';

class CategoriesController extends GetxController with StateMixin<List<CategoryUIModel>> {
  LocalCategoryRepository get _categoryRepo => Get.find();

  final _mapper = const CategoryUIMapper();
  StreamSubscription? _categorySubscription;

  @override
  void onInit() {
    super.onInit();

    _categorySubscription ??= _getCategories().handleError((Object e, StackTrace str) {
      change(null, status: RxStatus.error(str.toString()));
    }).listen((categories) {
      if (categories.isNotEmpty) {
        change(categories, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    _categorySubscription?.cancel();
    _categorySubscription = null;
  }

  Stream<List<CategoryUIModel>> _getCategories() {
    return _categoryRepo.categories.map((event) {
      return event
          .where((category) =>
              TransactionType.canAddCategory.contains(category.transactionType))
          .map(_mapper.map)
          .toList();
    });
  }

  void onAddClick() {
    Get.to(
      () => AddCategoryScreen(),
      binding: AddCategoryBinding(),
    );
  }
}
