import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateFilterProvider = StateProvider.autoDispose((ref) => DateFilter.empty);

final dateFilterValueProvider =
    StateNotifierProvider.autoDispose<_StateNotifier, DateFilterValues>(
  (ref) => _StateNotifier(),
);

class _StateNotifier extends StateNotifier<DateFilterValues> {
  _StateNotifier() : super(DateFilterValues());

  void setType(DateFilter type, [DateTime? sDate, DateTime? eDate]) {
    DateTime? startDate, endDate, onlyDate;

    switch (type) {
      case DateFilter.today:
        onlyDate = DateTime.now();
        break;
      case DateFilter.month:
        final date = DateTime.now();
        startDate = DateTime(date.year, date.month, 1);
        endDate = DateTime(date.year, date.month + 1, 0);
        break;
      case DateFilter.week:
        final date = DateTime.now();
        startDate =
            DateTime(date.year, date.month, date.day - date.weekday + 1);
        endDate =
            DateTime(date.year, date.month, date.day + (7 - date.weekday));
        break;
      case DateFilter.date:
        onlyDate = sDate;
        break;
      case DateFilter.empty:
        break;
      case DateFilter.range:
        startDate = sDate;
        endDate = eDate;
    }
    state = state.copyWith(
      type: type,
      startDate: startDate,
      endDate: endDate,
      date: onlyDate,
    );
  }
}

class DateFilterValues {
  DateFilterValues({
    this.startDate,
    this.endDate,
    this.date,
    this.type = DateFilter.empty,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? date;
  final DateFilter type;

  DateFilterValues copyWith({
    DateTime? startDate,
    DateTime? endDate,
    DateTime? date,
    DateFilter? type,
  }) =>
      DateFilterValues(
        startDate: startDate,
        endDate: endDate,
        date: date,
        type: type ?? this.type,
      );
}
