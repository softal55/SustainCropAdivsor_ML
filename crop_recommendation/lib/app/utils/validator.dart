abstract final class Validator {
  static String? Function(String?) requiredField(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }
      return null;
    };
  }

  static String? numericHardValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return 'Please enter a valid number for $fieldName';
    }

    if (parsedValue < 0) {
      return '$fieldName cannot be negative';
    }

    return null;
  }

  static String? getNumericRangeWarning(
    double value,
    String fieldName,
    double? min,
    double? max,
  ) {
    if (min != null && value < min) {
      return '$fieldName is less than $min';
    }
    if (max != null && value > max) {
      return '$fieldName is greater than $max';
    }
    return null; // No warning
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final pattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!pattern.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
