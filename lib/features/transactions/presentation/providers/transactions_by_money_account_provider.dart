import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTransactionsFilterProvider = StateNotifierProvider.autoDispose.family<
    PaginationNotifier<TransactionEntity>,
    AsyncValue<PaginationEntity<TransactionEntity>>,
    String>(
  (ref, maccId) {
    final repo = ref.watch(transactionsRepositoryProvider);
    final type = ref.watch(transactionTypeFilterProvider);
    final date = ref.watch(dateFilterValueProvider);

    print(date.startDate);

    return PaginationNotifier(
      params: GetTransactionsParams(
        type: type,
        page: 1,
        limit: 10,
        date: date.date,
        startDate: date.startDate,
        endDate: date.endDate,
        maccId: maccId,
      ),
      fetch: repo.getAll,
    )..init();
  },
);

class PaginationNotifier<T>
    extends StateNotifier<AsyncValue<PaginationEntity<T>>> {
  PaginationNotifier({
    required this.params,
    required this.fetch,
  }) : super(const AsyncValue.loading()) {
    _data = PaginationEntity(
      items: [],
      page: 0,
      nextPage: 1,
    );
  }

  final GetTransactionsParams params;
  final Future<PaginationEntity<T>> Function(GetTransactionsParams) fetch;
  late final PaginationEntity<T> _data;

  void init() {
    print('INIT');
    if (params.page <= 1) {
      fetchFirst();
    }
  }

  Future<void> fetchFirst() async {
    if (_data.page <= 1) {
      state = const AsyncValue.loading();
    }

    try {
      print(params);
      print(_data);
      final response = await fetch(
        GetTransactionsParams(
          type: params.type,
          page: _data.nextPage ?? 0,
          limit: params.limit,
          date: params.date,
          startDate: params.startDate,
          endDate: params.endDate,
          maccId: params.maccId,
        ),
      );
      state = AsyncValue.data(response);
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
    }
  }
}
