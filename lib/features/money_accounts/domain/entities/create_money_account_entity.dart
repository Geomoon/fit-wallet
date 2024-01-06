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
        'macc_name': name,
        'macc_amount': value,
        'macc_order': order,
      };
}
