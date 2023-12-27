import 'package:fit_wallet/features/money_accounts/domain/entities/money_account_entity.dart';

class MoneyAccountDbModel extends MoneyAccountEntity {
  MoneyAccountDbModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.createdAt,
    super.deletedAt,
    super.updatedAt,
  });

  factory MoneyAccountDbModel.fromJson(Map<String, dynamic> json) =>
      MoneyAccountDbModel(
        id: json['id'],
        name: json['name'],
        amount: json['amount']?.toDouble(),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        deletedAt: json['deletedAt'] == null
            ? null
            : DateTime.parse(json['deleted_at']),
      );
}
