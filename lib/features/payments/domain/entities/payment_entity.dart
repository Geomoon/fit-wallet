import 'package:fit_wallet/features/categories/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';

class PaymentEntity {
  PaymentEntity({
    required this.id,
    required this.description,
    required this.amount,
    required this.createdAt,
    this.hasDetails = false,
    this.amountPaid = 0,
    this.date,
    this.isCompleted = false,
    this.updatedAt,
    this.account,
    this.category,
  });

  String id;
  String description;
  double amount;
  double amountPaid;
  DateTime? date;
  bool isCompleted;
  bool hasDetails;
  DateTime createdAt;
  DateTime? updatedAt;
  MoneyAccountEntity? account;
  CategoryEntity? category;

  String get amountTxt => Utils.currencyFormat(amount);
  String get amountPaidTxt => Utils.currencyFormat(amountPaid);
  String get pendingAmountTxt => Utils.currencyFormat(amount - amountPaid);
  String get dateTxt => date == null ? '' : Utils.formatYYYDDMM(date!);

  double get pendingAmount => amount - amountPaid;

  bool get hasPriority {
    if (date == null || isCompleted) return false;
    return date!.difference(DateTime.now()).inDays <= 2;
  }

  bool get hasDiff {
    if (amountPaid == 0 || isCompleted) return false;
    if (amount != amountPaid) return true;
    return false;
  }
}
