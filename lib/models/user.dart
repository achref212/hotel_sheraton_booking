import 'dart:convert';

class User {
  String id;
  String name;
  String email;
  String token;
  String password;
  String profilePicturePath;
  String lastname;
  String birthdate;
  String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.password,
    this.profilePicturePath = "",
    this.lastname = "",
    this.birthdate = "",
    this.role = "user", // Match the default role in your back-end
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> userJson = json['user'] ?? {};
    return User(
      id: userJson['_id'] ?? '',
      email: userJson['email'] ?? '',
      password: userJson['password'] ?? '',
      name: userJson['name'] ?? '',
      lastname: userJson['lastname'] ?? '',
      birthdate: userJson['birthdate'] ?? '',
      role: userJson['role'] ?? "user",
      profilePicturePath: userJson['profile_picture'] ?? "",
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'token': token,
      'password': password,
      'profile_picture': profilePicturePath,
      'lastname': lastname,
      'birthdate': birthdate,
      'role': role,
    };
  }

  String toJson() => json.encode(toMap());
}
