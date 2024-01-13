import 'package:fit_wallet/features/shared/domain/entities/entities.dart';

class CreateTransactionEntity {
  String? description;
  double amount;
  TransactionType type;
  String? maccId;
  String cateId;
  String? paymId;
  String? maccIdTransfer;

  CreateTransactionEntity({
    this.description,
    required this.amount,
    required this.type,
    required this.cateId,
    this.maccId,
    this.paymId,
    this.maccIdTransfer,
  });

  Map<String, dynamic> toJson() => {
        'description': description == '' ? null : description,
        'amount': amount,
        'type': type.name.toUpperCase(),
        'maccId': maccId,
        'cateId': cateId,
        'paymId': paymId,
        'maccIdTransfer': maccIdTransfer,
      };
}
