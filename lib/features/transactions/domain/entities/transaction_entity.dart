import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';

class TransactionEntity {
  String id;
  String? description;
  double amount;
  String type;
  String userId;
  String? paymId; // TODO:
  DateTime createdAt;
  DateTime? deletedAt;
  MoneyAccount moneyAccount;
  MoneyAccount? moneyAccountTransfer;
  Category category;

  TransactionEntity({
    required this.id,
    this.description,
    required this.amount,
    required this.type,
    required this.userId,
    required this.paymId,
    required this.createdAt,
    required this.moneyAccount,
    this.moneyAccountTransfer,
    required this.category,
    this.deletedAt,
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      TransactionEntity(
        id: json["id"],
        description: json["description"],
        amount: json["amount"]?.toDouble(),
        type: json["type"],
        userId: json["userId"],
        paymId: json["debtId"],
        createdAt: DateTime.parse(json["createdAt"]),
        moneyAccount: MoneyAccount.fromJson(json["moneyAccount"]),
        category: Category.fromJson(json["category"]),
        deletedAt: json['deletedAt'] == null
            ? null
            : DateTime.parse(json['deletedAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "amount": amount,
        "type": type,
        "userId": userId,
        "paymId": paymId,
        "createdAt": createdAt.toIso8601String(),
        "moneyAccount": moneyAccount.toJson(),
        "category": category.toJson(),
        "deletedAt": deletedAt?.toIso8601String(),
      };

  String get amountTxt {
    String sign = '+';

    if (type == 'EXPENSE') sign = '-';
    if (type == 'TRANSFER') sign = '';

    return '$sign ${Utils.currencyFormat(amount)}';
  }

  String get dateTxt => Utils.formatYYYDDMM(createdAt);
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

  String get nameTxt => Utils.capitalText(name);
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

  String get shortNameTxt {
    final list = name.trim().split(' ');
    if (list.length == 1) {
      if (list[0].length >= 2) return list[0].substring(0, 2).toUpperCase();
      return list[0][0].toUpperCase();
    }

    final words = list.getRange(0, 2);

    return words.fold('', (previousValue, element) => element[0].toUpperCase());
  }
}
