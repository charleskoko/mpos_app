// ignore_for_file: non_constant_identifier_names

class Credential {
  String? name;
  String? email;
  String? mobile;
  String? password;
  String? password_confirmation;

  Credential(
      {this.name,
      this.email,
      this.mobile,
      this.password,
      this.password_confirmation});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'mobile': mobile,
        'password': password,
        'password_confirmation': password_confirmation
      };

  static Credential makeUserCredential(
      {name, email, password, password_confirmation}) {
    return Credential(
      name: name,
      email: email,
      password: password,
      password_confirmation: password_confirmation,
    );
  }
}
