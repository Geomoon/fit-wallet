import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';

final class TransactionsMapper {
  static Map<String, dynamic> createToJsonDb(CreateTransactionEntity entity) {
    return {
      'tran_description': entity.description == '' ? null : entity.description,
      'tran_amount': entity.amount,
      'tran_type': entity.type.name.toUpperCase(),
      'macc_id': entity.maccId,
      'cate_id': entity.cateId,
      'debt_id': entity.debtId,
      'macc_id_transfer': entity.maccIdTransfer,
    };
  }

  static TransactionEntity fromJsonDb(Map<String, dynamic> json) {
    final account = MoneyAccount(
      id: json['macc_id'],
      name: json['macc_name'],
    );

    final category = Category(
      id: json['cate_id'],
      name: json['cate_name'],
      hexColor: json['cate_hex_color'],
      icon: json['cate_icon'],
    );

    final transaction = TransactionEntity(
      id: json["tran_id"],
      description: json["tran_description"],
      amount: json["tran_amount"]?.toDouble(),
      type: json["tran_type"],
      userId: json["userId"] ?? '',
      debtId: json["debtId"] ?? '',
      createdAt: Utils.fromUnix(json["tran_created_at"]),
      moneyAccount: account,
      category: category,
      deletedAt: json['tran_deleted_at'] == null
          ? null
          : DateTime.parse(json['tran_deleted_at']),
    );

    return transaction;
  }
}
