mixin NameValidator {
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "Please, enter name";
    }
    if (name.length > 50) {
      return "Please, enter name below 50 symbols";
    }

    return null;
  }
}