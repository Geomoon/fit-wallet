class CreateMoneyAccountEntity {
  String name;
  double value;
  int order;

  CreateMoneyAccountEntity({
    required this.name,
    required this.value,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': value,
        'order': order,
      };
}
