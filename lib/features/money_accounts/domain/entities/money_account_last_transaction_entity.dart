import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';

class MoneyAccountLastTransactionEntity {
  String id;
  String name;
  double amount;
  String userId;
  int order;
  DateTime createdAt;
  DateTime? updatedAt;
  LastTransaction? lastTransaction;

  MoneyAccountLastTransactionEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.userId,
    required this.createdAt,
    required this.order,
    this.updatedAt,
    this.lastTransaction,
  });

  factory MoneyAccountLastTransactionEntity.fromJson(
    Map<String, dynamic> json,
  ) =>
      MoneyAccountLastTransactionEntity(
        id: json['id'],
        name: json['name'],
        amount: json['amount']?.toDouble(),
        userId: json['userId'],
        createdAt: DateTime.parse(json['createdAt']),
        order: json['order'],
        lastTransaction: json['lastTransaction'] == null
            ? null
            : LastTransaction.fromJson(json['lastTransaction']),
      );

  String get amountTxt => Utils.currencyFormat(amount);

  String get shortNameTxt {
    final list = name.trim().split(' ');
    if (list.length == 1) {
      if (list[0].length >= 2) return list[0].substring(0, 2).toUpperCase();
      // return list[0][0].toUpperCase();
      return '';
    }

    final words = list.getRange(0, 2);
    return words.map((e) => e[0].toUpperCase()).join('');
  }

  String get lastTransactionTxt {
    if (lastTransaction == null) return '';

    return Utils.formatYYYDDMM(lastTransaction!.createdAt);
  }
}

class LastTransaction {
  String id;
  double amount;
  String? description;
  TransactionType type;
  DateTime createdAt;

  LastTransaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.type,
    required this.createdAt,
  });

  factory LastTransaction.fromJson(Map<String, dynamic> json) =>
      LastTransaction(
        id: json['id'],
        amount: json['amount']?.toDouble(),
        description: json['description'],
        type: TransactionTypeMapper.fromString(json['type']),
        createdAt: DateTime.parse(json['createdAt']),
      );

  factory LastTransaction.fromJsonDB(Map<String, dynamic> json) =>
      LastTransaction(
        id: json['id'],
        amount: json['amount']?.toDouble(),
        description: json['description'],
        type: TransactionTypeMapper.fromString(json['type']),
        createdAt: DateTime.parse(json['created_at']),
      );
}
