import 'package:fit_wallet/features/shared/domain/entities/transaction_type_entity.dart';

class TransactionTypeMapper {
  static TransactionType fromString(String type) {
    switch (type.toUpperCase()) {
      case 'TRANSFER':
        return TransactionType.transfer;
      case 'INCOME':
        return TransactionType.income;
      case 'EXPENSE':
        return TransactionType.expense;
      default:
        return TransactionType.income;
    }
  }
}
