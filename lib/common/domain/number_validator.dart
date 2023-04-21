mixin NumberValidator {
  String? validateNumber(String? value) {
    if (value == null || double.tryParse(value) == null) {
      return "Incorrect number";
    }
    return null;
  }
}