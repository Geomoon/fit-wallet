class TransactionEntity {
  String id;
  String description;
  int amount;
  String type;
  String userId;
  dynamic debtId; // TODO:
  DateTime createdAt;
  MoneyAccount moneyAccount;
  Category category;

  TransactionEntity({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.userId,
    required this.debtId,
    required this.createdAt,
    required this.moneyAccount,
    required this.category,
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      TransactionEntity(
        id: json["id"],
        description: json["description"],
        amount: json["amount"],
        type: json["type"],
        userId: json["userId"],
        debtId: json["debtId"],
        createdAt: DateTime.parse(json["createdAt"]),
        moneyAccount: MoneyAccount.fromJson(json["moneyAccount"]),
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "amount": amount,
        "type": type,
        "userId": userId,
        "debtId": debtId,
        "createdAt": createdAt.toIso8601String(),
        "moneyAccount": moneyAccount.toJson(),
        "category": category.toJson(),
      };
}

class Category {
  String id;
  String name;
  String hexColor;
  String icon;

  Category({
    required this.id,
    required this.name,
    required this.hexColor,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        hexColor: json["hexColor"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "hexColor": hexColor,
        "icon": icon,
      };
}

class MoneyAccount {
  String id;
  String name;

  MoneyAccount({
    required this.id,
    required this.name,
  });

  factory MoneyAccount.fromJson(Map<String, dynamic> json) => MoneyAccount(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
