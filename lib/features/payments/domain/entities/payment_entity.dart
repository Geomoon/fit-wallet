import 'package:fit_wallet/features/categories/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';

class PaymentEntity {
  PaymentEntity({
    required this.id,
    required this.description,
    required this.amount,
    required this.createdAt,
    this.date,
    this.isCompleted = false,
    this.updatedAt,
    this.account,
    this.category,
  });

  String id;
  String description;
  double amount;
  DateTime? date;
  bool isCompleted;
  DateTime createdAt;
  DateTime? updatedAt;
  MoneyAccountEntity? account;
  CategoryEntity? category;

  String get amountTxt => Utils.currencyFormat(amount);
  String get dateTxt => date == null ? '' : Utils.formatYYYDDMM(date!);
}
