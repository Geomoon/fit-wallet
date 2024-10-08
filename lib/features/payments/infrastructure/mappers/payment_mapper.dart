import 'package:fit_wallet/features/categories/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';

final class PaymentMapper {
  static PaymentEntity fromJsonDB(Map<String, dynamic> json) {
    final payment = PaymentEntity(
      id: json['paym_id'],
      description: json['paym_description'],
      hasDetails: json['paym_has_details'] > 0,
      amount: double.parse(json['paym_amount'].toString()),
      amountPaid: json['paym_amount_paid'] == null
          ? 0
          : double.parse(json['paym_amount_paid'].toString()),
      createdAt: Utils.fromUnix(json['paym_created_at']),
      updatedAt: json['paym_updated_at'] == null
          ? null
          : Utils.fromUnix(json['paym_updated_at']),
      date:
          json['paym_date'] == null ? null : Utils.fromUnix(json['paym_date']),
    );

    if (json['macc_id'] != null) {
      payment.account = MoneyAccountEntity(
        id: json['macc_id'],
        name: json['macc_name'],
        amount: json['macc_amount'] ?? 0,
      );
    }

    if (json['cate_id'] != null) {
      payment.category = CategoryEntity(
        id: json['cate_id'],
        name: json['cate_name'],
      );
    }

    return payment;
  }

  static Map<String, dynamic> toJsonDb(PaymentEntity payment) {
    return {
      'paym_id': payment.id,
      'paym_description': payment.description,
      'paym_amount': payment.amount,
      'paym_amount_paid': payment.amountPaid,
      'paym_date': payment.date == null ? null : Utils.unix(payment.date!),
      'paym_is_completed': payment.isCompleted ? 1 : 0,
      'paym_created_at': Utils.unix(payment.createdAt),
      'paym_updated_at':
          payment.updatedAt == null ? null : Utils.unix(payment.updatedAt!),
      'macc_id': payment.account?.id,
      'cate_id': payment.category?.id,
    };
  }
}
