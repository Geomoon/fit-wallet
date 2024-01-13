import 'package:fit_wallet/features/transactions/domain/domain.dart';

class TransactionSimpleEntity {
  String id;
  double amount;
  String type;
  DateTime createdAt;
  MoneyAccount moneyAccount;
  Category category;

  TransactionSimpleEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.moneyAccount,
    required this.category,
  });
}
