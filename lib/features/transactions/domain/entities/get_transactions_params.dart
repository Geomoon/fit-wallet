import 'package:fit_wallet/features/shared/domain/domain.dart';

class GetTransactionsParams extends PaginationParams {
  GetTransactionsParams({
    this.date,
    this.startDate,
    this.endDate,
    this.maccId,
    required this.type,
    required super.page,
    required super.limit,
  });

  final DateTime? date;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? maccId;
  final TransactionTypeFilter type;

  @override
  Map<String, dynamic> toJson() {
    final map = {
      'date': date,
      'startDate': startDate,
      'endDate': endDate,
      'maccId': maccId,
      'type': type.name.toUpperCase(),
      'page': page,
      'limit': limit,
    };
    final list = map.entries.where((element) => element.value != null);

    return Map.fromEntries(list);
  }
}
