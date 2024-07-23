import 'Constants/constants.dart';

class AppValidator {
  static bool isEmail(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }
    final exp = RegExp(emailPattern);
    return exp.hasMatch(email);
  }
  static bool isValidDateFormat(String? date) {
    if (date == null || date.isEmpty) {
      return false;
    }

    final RegExp regex = RegExp(r'^\d{4}-\d{2}$');
    return regex.hasMatch(date);
  }

  static bool isPassword(String? password) {
    if (password == null || password.isEmpty || password.length < 8) {
      return false;
    }
    //return true;
    //  final exp = RegExp(Constants.passwordPatternSpecial);
    // final exp1 = RegExp(Constants.passwordPatternNumeric);

    // return exp.hasMatch(password) ;//|| exp1.hasMatch(password);
    return true;
  }
}
