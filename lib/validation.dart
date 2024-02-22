// ignore: camel_case_extensions
// ignore_for_file: unnecessary_null_comparison, camel_case_extensions, duplicate_ignore

extension extString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName{
    final nameRegExp = RegExp(r"^\s*([A-Za-z])+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidOrgName{
    final nameRegExp = RegExp(r"^\s*([A-Za-z])+[ ]+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword{
    final passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull{
    return this != null;
  }

  bool get isValidPhone{
    //final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    final phoneRegExp = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidUniqueId{
    final uniqueRegExp = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    return uniqueRegExp.hasMatch(this);
  }

}