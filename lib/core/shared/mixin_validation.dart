mixin ValidationMixin {
  bool isPasswordValid(String password) => password.length >= 8;
  bool isTextfieldNotEmpty(String value) => value.isNotEmpty;
  bool isPhoneNumberValid(String phoneNumber) => phoneNumber.length >= 10;
  bool isPasswordConfirmed(String password, String passwordToConfirm) {
    if (password.toLowerCase() == passwordToConfirm.toLowerCase()) {
      return true;
    }
    return false;
  }

  bool isNumeric<T>(T? value) => value.runtimeType == T;
  bool isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}
