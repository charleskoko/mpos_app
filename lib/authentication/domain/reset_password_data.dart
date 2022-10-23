// ignore_for_file: non_constant_identifier_names

class ResetPasswordData {
  String? code;
  String? email;
  String? password;
  String? password_confirmation;

  ResetPasswordData({this.code, this.password, this.password_confirmation});

  Map<String, dynamic> toJson() => {
        'code': code,
        'password': password,
        'password_confirmation': password_confirmation
      };

  static ResetPasswordData makeUserCredential(
      {name, email, password, password_confirmation}) {
    return ResetPasswordData(
      code: name,
      password: password,
      password_confirmation: password_confirmation,
    );
  }
}
