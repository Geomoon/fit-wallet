import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/shared/infrastructure/mappers/mappers.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';

final class MoneyAccountMapper {
  static MoneyAccountLastTransactionEntity fromApi(Map<String, dynamic> json) =>
      MoneyAccountLastTransactionEntity.fromJson(json);

  static MoneyAccountLastTransactionEntity fromDb(Map<String, dynamic> json) {
    final account = MoneyAccountLastTransactionEntity(
      id: json['macc_id'],
      name: json['macc_name'],
      amount: json['macc_amount']?.toDouble(),
      userId: json['user_id'] ?? '',
      createdAt: Utils.fromUnix(json['macc_created_at']),
      order: json['macc_order'],
    );

    if (json['tran_id'] != null) {
      final transaction = LastTransaction(
        id: json['tran_id'],
        amount: json['tran_amount']?.toDouble(),
        description: json['tran_description'],
        type: TransactionTypeMapper.fromString(json['tran_type']),
        createdAt: DateTime.parse(json['tran_created_at']),
      );
      account.lastTransaction = transaction;
    }

    return account;
  }

  static MoneyAccountEntity fromDbToEntity(Map<String, dynamic> json) {
    return MoneyAccountEntity(
      id: json['macc_id'],
      name: json['macc_name'],
      amount: json['macc_amount']?.toDouble(),
      order: json['macc_order'],
      createdAt: json['macc_createdAt'],
    );
  }

  static Map<String, dynamic> entityToJsonDb(MoneyAccountEntity entity) {
    return {
      'macc_id': entity.id,
      'macc_name': entity.name,
      'macc_amount': entity.amount,
      'macc_order': entity.order,
      'macc_created_at':
          entity.createdAt == null ? null : Utils.unix(entity.createdAt!),
      'macc_updated_at':
          entity.updatedAt == null ? null : Utils.unix(entity.updatedAt!),
      'macc_deleted_at':
          entity.deletedAt == null ? null : Utils.unix(entity.deletedAt!),
    };
  }

  static Map<String, dynamic> entityToJsonDbUpdate(MoneyAccountEntity entity) {
    return {
      'macc_name': entity.name,
      'macc_amount': entity.amount,
      'macc_order': entity.order,
      'macc_updated_at':
          entity.updatedAt == null ? null : Utils.unix(entity.updatedAt!),
      'macc_deleted_at':
          entity.deletedAt == null ? null : Utils.unix(entity.deletedAt!),
    };
  }
}
