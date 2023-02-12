import 'dart:async';

import 'package:get/get.dart';

import '../../add/domain/add_category_binding.dart';
import '../../add/ui/add_category_screen.dart';
import '../../common/data/local_category_repository.dart';
import '../ui/models/category_ui_model.dart';
import 'mappers/category_ui_mapper.dart';

class CategoriesController extends GetxController {
  LocalCategoryRepository get _categoryRepo => Get.find();

  final CategoryUIMapper _mapper = CategoryUIMapper();

  RxList<CategoryUIModel> categories = <CategoryUIModel>[].obs;
  StreamSubscription? _listener;

  @override
  void onReady() {
    _listener?.cancel();
    _listener = _categoryRepo.categories.listen((event) {
      categories.value = event.map(_mapper.map).toList();
    });

    super.onReady();
  }

  @override
  void onClose() {
    _listener?.cancel();
    _listener = null;
    super.onClose();
  }

  void onAddClick() {
    Get.to(
          () => AddCategoryScreen(),
      binding: AddCategoryBinding(),
    );
  }
}