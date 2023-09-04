class CreateMoneyAccountEntity {
  String name;
  double value;

  CreateMoneyAccountEntity({
    required this.name,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };
}
