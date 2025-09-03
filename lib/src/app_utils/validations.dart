/// Validates email format
String? validateEmail({required String string}) {
  const String regex = r'^[a-zA-Z0-9._+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$';

  if (string.trim().isEmpty) {
    return "Email is required";
  } else if (string.length > 254) {
    return "Email must be up to 254 characters";
  } else if (!RegExp(regex).hasMatch(string.trim())) {
    return "Invalid email format";
  } else {
    return null;
  }
}

/// Validates password with English-only rules
String? validatePassword({
  required String string,
}) {
  final RegExp allowedCharacters = RegExp(r'^[!@#$%^&*()_+~`A-Za-z0-9]+$');
  final RegExp containsSpace = RegExp(r'\s');

  if (string.isEmpty) {
    return "Password is required";
  } else if (string.length < 8) {
    return "Password must be at least 8 characters";
  } else if (string.length > 25) {
    return "Password must be at most 25 characters";
  } else if (containsSpace.hasMatch(string)) {
    return "Spaces are not allowed";
  } else if (!allowedCharacters.hasMatch(string)) {
    return "Only letters, numbers, and special characters are allowed";
  } else {
    return null;
  }
}

/// Validates confirm password with English-only rules
String? validateConfirmPassword({
  required String password,
  required String confirmPassword,
}) {
  final RegExp allowedCharacters = RegExp(r'^[!@#$%^&*()_+~`A-Za-z0-9]+$');
  final RegExp containsSpace = RegExp(r'\s');

  if (confirmPassword.isEmpty) {
    return "Confirm Password is required";
  } else if (confirmPassword != password) {
    return "Passwords do not match";
  } else if (containsSpace.hasMatch(confirmPassword)) {
    return "Spaces are not allowed";
  } else if (!allowedCharacters.hasMatch(confirmPassword)) {
    return "Only letters, numbers, and special characters are allowed";
  } else {
    return null;
  }
}

//validate is empty
String? validateIsEmpty({required String string}) {
  // Check if the trimmed string is empty
  if (string.trim().isEmpty) {
    return "Field can't be empty";
  }
  return null;
}
