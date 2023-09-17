import 'package:fit_wallet/features/shared/domain/entities/entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionTypeProvider = StateProvider((ref) => TransactionType.expense);
