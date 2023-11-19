import 'package:fit_wallet/features/shared/domain/entities/entities.dart';

class CreateTransactionEntity {
  String? description;
  double amount;
  TransactionType type;
  String maccId;
  String cateId;
  String? debtId;
  String? maccIdTransfer;

  CreateTransactionEntity({
    this.description,
    required this.amount,
    required this.type,
    required this.maccId,
    required this.cateId,
    this.debtId,
    this.maccIdTransfer,
  });

  Map<String, dynamic> toJson() => {
        'description': description == '' ? null : description,
        'amount': amount,
        'type': type.name.toUpperCase(),
        'maccId': maccId,
        'cateId': cateId,
        'debtId': debtId,
        'maccIdTransfer': maccIdTransfer,
      };
}
