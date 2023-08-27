class AuthEntity {
  String accessToken;
  String refreshToken;

  AuthEntity({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthEntity.fromJson(Map<String, dynamic> json) => AuthEntity(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}
