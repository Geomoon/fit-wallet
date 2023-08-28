class JwtEntity {
  String email;
  String sub;
  bool verified;
  DateTime iat;
  DateTime exp;

  JwtEntity({
    required this.email,
    required this.sub,
    required this.verified,
    required this.iat,
    required this.exp,
  });

  factory JwtEntity.fromJson(Map<String, dynamic> json) => JwtEntity(
        email: json['email'],
        sub: json['sub'],
        verified: json['verified'],
        iat: json['iat'] == null
            ? DateTime(1900)
            : DateTime.fromMillisecondsSinceEpoch(json['iat'] * 1000),
        exp: json['exp'] == null
            ? DateTime(1900)
            : DateTime.fromMillisecondsSinceEpoch(json['exp'] * 1000),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'sub': sub,
        'verified': verified,
        'iat': iat,
        'exp': exp,
      };
}
