class MoneyAccountEntity {
  String id;
  String name;
  double amount;
  int? order;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  MoneyAccountEntity({
    required this.id,
    required this.name,
    required this.amount,
    this.createdAt,
    this.order,
    this.updatedAt,
    this.deletedAt,
  });

  factory MoneyAccountEntity.fromJson(Map<String, dynamic> json) =>
      MoneyAccountEntity(
        id: json['id'],
        name: json['name'],
        amount: json['amount']?.toDouble(),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        order: json['order'],
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        deletedAt: json['deletedAt'] == null
            ? null
            : DateTime.parse(json['deletedAt']),
      );
}
