import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';

class BalanceEntity {
  BalanceDetail incomes;
  BalanceDetail expenses;
  BalanceDetail balance;

  BalanceEntity({
    required this.incomes,
    required this.expenses,
    required this.balance,
  });

  factory BalanceEntity.fromJson(Map<String, dynamic> json) => BalanceEntity(
        incomes: BalanceDetail.fromJson(json['incomes']),
        expenses: BalanceDetail.fromJson(json['expenses']),
        balance: BalanceDetail.fromJson(json['balance']),
      );
}

class BalanceDetail {
  double value;

  BalanceDetail(this.value);

  factory BalanceDetail.fromJson(Map<String, dynamic> json) =>
      BalanceDetail(json['value'].toDouble());

  String get valueTxt => Utils.currencyFormat(value);
}
