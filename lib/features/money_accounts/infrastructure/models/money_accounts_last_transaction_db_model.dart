import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';

class MoneyAccountLastTransactionDbEntity
    extends MoneyAccountLastTransactionEntity {
  MoneyAccountLastTransactionDbEntity({
    required super.id,
    required super.name,
    required super.amount,
    required super.userId,
    required super.createdAt,
    required super.order,
    super.updatedAt,
    super.lastTransaction,
  });

  factory MoneyAccountLastTransactionDbEntity.fromJson(
    Map<String, dynamic> json,
  ) =>
      MoneyAccountLastTransactionDbEntity(
        id: json['macc_id'],
        name: json['macc_name'],
        amount: json['macc_amount']?.toDouble(),
        userId: json['user_id'] ?? '',
        createdAt: Utils.fromUnix(json['macc_created_at']),
        order: json['macc_order'],
      );
}

class LastTransactionDb extends LastTransaction {
  LastTransactionDb({
    required super.id,
    required super.amount,
    required super.description,
    required super.type,
    required super.createdAt,
  });

  factory LastTransactionDb.fromJson(Map<String, dynamic> json) =>
      LastTransactionDb(
        id: json['tran_id'],
        amount: json['tran_amount']?.toDouble(),
        description: json['tran_description'],
        type: TransactionTypeMapper.fromString(json['tran_type']),
        createdAt: DateTime.parse(json['tran_created_at']),
      );
}
