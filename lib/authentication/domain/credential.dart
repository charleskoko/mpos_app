class Credential {
  String? name;
  String? email;
  String? password;
  String? password_confirmation;

  Credential(
      {this.name, this.email, this.password, this.password_confirmation});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation
      };

  static Credential makeUserCredential(
      // ignore: non_constant_identifier_names
      {name,
      email,
      password,
      password_confirmation}) {
    return Credential(
      name: name,
      email: email,
      password: password,
      password_confirmation: password_confirmation,
    );
  }
}
