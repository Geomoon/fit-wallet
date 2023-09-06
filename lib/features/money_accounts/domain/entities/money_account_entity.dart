class MoneyAccountEntity {
  String id;
  String name;
  double amount;
  DateTime createdAt;
  DateTime? updatedAt;

  MoneyAccountEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    this.updatedAt,
  });

  factory MoneyAccountEntity.fromJson(Map<String, dynamic> json) =>
      MoneyAccountEntity(
        id: json['id'],
        name: json['name'],
        amount: json['amount']?.toDouble(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
      );
}
