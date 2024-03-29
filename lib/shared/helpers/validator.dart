class Validator {
  static String? empty(
    String? value, {
    required String field,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $field';
    }
    return null;
  }

  static String? email(String? value) {
    String? emptyCheck = empty(value, field: 'email');
    if (emptyCheck != null) return emptyCheck;

    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
