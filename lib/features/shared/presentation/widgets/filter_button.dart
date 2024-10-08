import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/money_accounts/presentation/screens/money_accounts_detail_screen.dart';
import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FilterButton extends ConsumerWidget {
  const FilterButton({
    super.key,
  });

  void _showDialogFilter(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          showDragHandle: false,
          enableDrag: false,
          builder: (context) {
            return DatePickerBottomDialog(
              onPickDate: (f) {
                context.pop();
                _showDatePickerDialog(context, f);
              },
            );
          },
        );
      },
    );
  }

  void _showDatePickerDialog(BuildContext context, bool isRange) async {
    if (isRange) {
      await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, ref, _) {
            return CalendarRangePickerBottomDialog(
              title: AppLocalizations.of(context)!.pickDate,
              firstDate: ref.watch(dateFilterValueProvider).startDate,
              lastDate: ref.watch(dateFilterValueProvider).endDate,
              onStartDateChanged: (d) => ref
                  .read(dateFilterValueProvider.notifier)
                  .setType(DateFilter.range, d),
              onEndDateChanged: (d) => ref
                  .read(dateFilterValueProvider.notifier)
                  .setType(DateFilter.range,
                      ref.read(dateFilterValueProvider).startDate, d),
            );
          });
        },
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, _) {
          return CalendarPickerBottomDialog(
            title: AppLocalizations.of(context)!.byDate,
            onDateChanged: (d) => ref
                .read(dateFilterValueProvider.notifier)
                .setType(DateFilter.date, d),
          );
        });
      },
    );
  }

  String title(BuildContext context, DateFilter type) {
    switch (type) {
      case DateFilter.empty:
        return AppLocalizations.of(context)!.byDate;
      case DateFilter.today:
        return AppLocalizations.of(context)!.today;
      case DateFilter.week:
        return AppLocalizations.of(context)!.thisWeek;
      case DateFilter.month:
        return AppLocalizations.of(context)!.thisMonth;
      case DateFilter.date:
        return AppLocalizations.of(context)!.byDate;
      default:
        return AppLocalizations.of(context)!.byDate;
    }
  }

  IconData icon(DateFilter type) {
    switch (type) {
      case DateFilter.empty:
        return Icons.calendar_view_day_rounded;
      case DateFilter.today:
        return Icons.calendar_today_rounded;
      case DateFilter.week:
        return Icons.calendar_view_week_rounded;
      case DateFilter.month:
        return Icons.calendar_month_rounded;
      default:
        return Icons.calendar_view_day_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = DarkTheme.primaryFilterStyle;

    final filter = ref.watch(dateFilterValueProvider);

    return ElevatedButton(
      style: style,
      onPressed: () => _showDialogFilter(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title(context, filter.type)),
          if (filter.type != DateFilter.date) const SizedBox(width: 10),
          if (filter.type != DateFilter.date) Icon(icon(filter.type), size: 18),
        ],
      ),
    );
  }
}
