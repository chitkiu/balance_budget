import '../../../common/data/models/category.dart';
import '../../ui/models/category_ui_model.dart';

class CategoryUIMapper {
  const CategoryUIMapper();

  CategoryUIModel map(Category category) {
    return CategoryUIModel(
      category.title,
      category.id,
      category.icon,
    );
  }
}