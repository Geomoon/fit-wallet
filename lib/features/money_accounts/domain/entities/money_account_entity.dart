class MoneyAccountEntity {
  String id;
  String name;
  double amount;
  String userId;
  DateTime createdAt;
  DateTime? updatedAt;

  MoneyAccountEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });
}
