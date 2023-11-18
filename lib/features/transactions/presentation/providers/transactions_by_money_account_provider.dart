import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTransactionsFilterProvider = StateNotifierProvider.autoDispose
    .family<PaginationNotifier<TransactionEntity>, _State, String>(
  (ref, maccId) {
    final repo = ref.watch(transactionsRepositoryProvider);
    final type = ref.watch(transactionTypeFilterProvider);
    final date = ref.watch(dateFilterValueProvider);

    return PaginationNotifier(
      dateFilter: date,
      type: type,
      fetch: repo.getAll,
      maccId: maccId,
    )..init();
  },
);

class PaginationNotifier<T> extends StateNotifier<_State> {
  PaginationNotifier({
    required this.maccId,
    required this.fetch,
    required this.type,
    required this.dateFilter,
    this.limit = 25,
  }) : super(_State(page: 1));

  final Future<PaginationEntity<T>> Function(GetTransactionsParams) fetch;
  final String maccId;
  final TransactionTypeFilter type;
  final DateFilterValues dateFilter;
  final int limit;

  void init() {
    if (state.page == 1) {
      fetchFirst();
    }
  }

  Future<void> fetchFirst() async {
    if (state.isLoading || state.isLoadingMore) return;

    state = state.copyWith(isLoading: true);
    try {
      final response = await fetch(
        GetTransactionsParams(
          type: type,
          page: 1,
          limit: limit,
          date: dateFilter.date,
          startDate: dateFilter.startDate,
          endDate: dateFilter.endDate,
          maccId: maccId,
        ),
      );
      state = state.copyWith(
        page: response.nextPage,
        isLoading: false,
        items: response.items,
        errorLoading: '',
      );
    } catch (e) {
      state =
          state.copyWith(errorLoading: 'Error at loading', isLoading: false);
    }
  }

  Future<void> fetchNext() async {
    if (state.isLoading || state.isLoadingMore || state.page == null) return;

    state = state.copyWith(isLoadingMore: true, page: state.page);

    try {
      final response = await fetch(
        GetTransactionsParams(
          type: type,
          page: state.page!,
          limit: limit,
          date: dateFilter.date,
          startDate: dateFilter.startDate,
          endDate: dateFilter.endDate,
          maccId: maccId,
        ),
      );
      state = state.copyWith(
        page: response.nextPage,
        isLoadingMore: false,
        isLoading: false,
        items: state.items..addAll(response.items),
        errorLoading: '',
      );
    } catch (e) {
      state = state.copyWith(
        errorLoading: 'Error at loading',
        isLoadingMore: false,
      );
    }
  }
}

class _State<T> {
  _State({
    this.page,
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorLoading = '',
    this.errorLoadingMore = '',
  });

  final int? page;
  final List<T> items;
  final bool isLoadingMore;
  final bool isLoading;
  final String errorLoading;
  final String errorLoadingMore;

  _State copyWith({
    int? page,
    List<T>? items,
    bool? isLoadingMore,
    bool? isLoading,
    String? errorLoading,
    String? errorLoadingMore,
  }) =>
      _State(
        page: page,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        items: items ?? this.items,
        errorLoading: errorLoading ?? this.errorLoading,
        errorLoadingMore: errorLoadingMore ?? this.errorLoadingMore,
      );
}
