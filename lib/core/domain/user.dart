class User {
  String? id;
  String? name;
  String? email;

  User({required this.id, required this.name, required this.email});

  User.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    name = jsonObject["name"].toString();
    email = jsonObject["email"].toString();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
