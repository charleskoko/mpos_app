class User {
  String? id;
  String? name;
  String? mobile;
  String? uniqueNumber;
  String? email;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.uniqueNumber,
  });

  User.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    name = jsonObject["name"].toString();
    mobile = jsonObject["mobile"].toString();
    uniqueNumber = jsonObject["unique_number"].toString();
    email = jsonObject["email"].toString();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile': mobile,
        'unique_number': uniqueNumber,
      };
}
