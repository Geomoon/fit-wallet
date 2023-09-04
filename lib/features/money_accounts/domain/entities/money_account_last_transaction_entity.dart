import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';

class MoneyAccountLastTransactionEntity {
  String id;
  String name;
  double amount;
  String userId;
  DateTime createdAt;
  DateTime? updatedAt;
  LastTransaction? lastTransaction;

  MoneyAccountLastTransactionEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.userId,
    required this.createdAt,
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
        lastTransaction: json['lastTransaction'] == null
            ? null
            : LastTransaction.fromJson(json['lastTransaction']),
      );

  String get amountTxt => Utils.currencyFormat(amount);

  String get shortNameTxt =>
      name.split(' ').map((e) => e[0].toUpperCase()).join();

  String get lastTransactionTxt {
    if (lastTransaction == null) return 'No transactions';

    return Utils.formatYYYDDMM(lastTransaction!.createdAt);
  }
}

class LastTransaction {
  String id;
  double amount;
  String description;
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
}
