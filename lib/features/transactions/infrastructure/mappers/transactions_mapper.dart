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
}
