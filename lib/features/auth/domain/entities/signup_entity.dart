class SignUpEntity {
  String username;
  String email;
  String password;
  DateTime birthdate;

  SignUpEntity({
    required this.username,
    required this.email,
    required this.password,
    required this.birthdate,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'birthdate': birthdate.toIso8601String(),
      };
}
