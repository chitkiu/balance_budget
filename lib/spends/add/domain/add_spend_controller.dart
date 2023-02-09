import 'dart:async';

import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../categories/add/domain/add_category_binding.dart';
import '../../../categories/add/ui/add_category_screen.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category_id.dart';
import '../../common/data/local_spend_repository.dart';
import '../ui/models/spend_category_ui_model.dart';
import 'mappers/spend_category_ui_mapper.dart';

class AddSpendController extends GetxController {
  final SpendCategoryUIMapper _spendCategoryUIMapper = SpendCategoryUIMapper();

  LocalSpendRepository get _spendRepo => Get.find();

  LocalCategoryRepository get _categoryRepo => Get.find();

  RxList<SpendCategoryUIModel> categoryList = <SpendCategoryUIModel>[].obs;

  Rxn<CategoryId> selectedCategory = Rxn();

  StreamSubscription? _subscription;

  @override
  void onReady() {
    _subscription?.cancel();

    //TODO Move to separate class
    _subscription = CombineLatestStream.combine2(
      _categoryRepo.categories.stream,
      selectedCategory.stream,
      _spendCategoryUIMapper.map,
    ).listen((value) {
      categoryList.value = value;
    });

    //Add refresh for set initial data
    _categoryRepo.categories.refresh();
    selectedCategory.refresh();

    super.onReady();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _subscription = null;
    super.onClose();
  }

  void onSaveSpend(String sum, String comment) {
    String? currentComment = comment;
    if (comment.isEmpty) {
      currentComment = null;
    }

    var categoryId = selectedCategory.value;
    //TODO Add error
    if (double.tryParse(sum) == null) {
      return;
    }

    if (categoryId == null) {
      return;
    }

    _spendRepo.create(
        double.parse(sum),
        categoryId,
        DateTime.now(),
        currentComment
    );

    Get.back();
  }

  void selectCategory(SpendCategoryUIModel category) {
    selectedCategory.value = category.categoryId;
  }

  void onAddCategoryClick() {
    Get.to(
      () => AddCategoryScreen(),
      binding: AddCategoryBinding(),
    );
  }
}
