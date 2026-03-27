import 'package:flutter/material.dart';
import '../../../data/models/stock_model.dart';
import 'calendar_card.dart';
import '../calendar_helper.dart';
import '../../../utils/global.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Change this one constant to switch the entire calendar layout
// ─────────────────────────────────────────────────────────────────────────────
enum CalendarLayout { gridClassic, timeline, compactTable, weekStrip, spotGrid }

const CalendarLayout kCalendarLayout = CalendarLayout.gridClassic;

class CalendarBody extends StatelessWidget {
  final DateTime month;
  final List<StockModel> list;

  const CalendarBody({super.key, required this.month, required this.list});

  @override
  Widget build(BuildContext context) {
    final dates   = CalendarHelper.getWeekdayDays(month);
    final mm      = '${month.month}'.padLeft(2, '0');
    final yyyy    = '${month.year}';

    // Build unified cell data
    final cells = List.generate(25, (i) {
      final dateStr = dates[i].toString().padLeft(2, '0');
      final idx = list.indexWhere((e) => e.date?.split('/').first == dateStr);
      final offIdx = Global.config.setHoliday?.indexWhere(
            (s) => '${s.date}'.split('T')[0] == '$yyyy-$mm-$dateStr') ?? -1;
      return _CellData(
        date: dateStr,
        twod: idx != -1 ? list[idx] : null,
        offDay: offIdx != -1,
        month: month,
      );
    });

    switch (kCalendarLayout) {
      case CalendarLayout.gridClassic:
        return _GridClassicLayout(cells: cells);
      case CalendarLayout.timeline:
        return _TimelineLayout(cells: cells);
      case CalendarLayout.compactTable:
        return _CompactTableLayout(cells: cells);
      case CalendarLayout.weekStrip:
        return _WeekStripLayout(cells: cells);
      case CalendarLayout.spotGrid:
        return _SpotGridLayout(cells: cells);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared cell data model
// ─────────────────────────────────────────────────────────────────────────────
class _CellData {
  final String date;
  final StockModel? twod;
  final bool offDay;
  final DateTime month;
  bool get isEmpty => date == '00';
  _CellData({required this.date, required this.twod, required this.offDay, required this.month});
}

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 1 — Grid Classic (original 5×5 grid, aspect 0.8)
// ═════════════════════════════════════════════════════════════════════════════
class _GridClassicLayout extends StatelessWidget {
  final List<_CellData> cells;
  const _GridClassicLayout({required this.cells});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 25,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (_, i) {
        final c = cells[i];
        if (c.isEmpty) return const SizedBox();
        return CalendarCard(date: c.date, twod: c.twod, offDay: c.offDay, month: c.month);
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 2 — Timeline  (vertical list, week separator, result inline right)
// ═════════════════════════════════════════════════════════════════════════════
class _TimelineLayout extends StatelessWidget {
  final List<_CellData> cells;
  const _TimelineLayout({required this.cells});

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    // Group into rows of 5 (Mon–Fri weeks)
    final weeks = <List<_CellData>>[];
    for (int i = 0; i < cells.length; i += 5) {
      weeks.add(cells.sublist(i, i + 5));
    }

    return Column(
      children: List.generate(weeks.length, (wi) {
        final week = weeks[wi];
        final realDays = week.where((c) => !c.isEmpty).toList();
        if (realDays.isEmpty) return const SizedBox();

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161B22) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade100,
            ),
          ),
          child: Column(
            children: List.generate(realDays.length, (di) {
              final c = realDays[di];
              final isLast = di == realDays.length - 1;
              return CalendarCard(
                date: c.date, twod: c.twod, offDay: c.offDay, month: c.month,
                layoutHint: CalendarLayout.timeline,
                isLastInGroup: isLast,
              );
            }),
          ),
        );
      }),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 3 — Compact Table  (spreadsheet rows, alternating row bg, no gaps)
// ═════════════════════════════════════════════════════════════════════════════
class _CompactTableLayout extends StatelessWidget {
  final List<_CellData> cells;
  const _CompactTableLayout({required this.cells});

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;

    final weeks = <List<_CellData>>[];
    for (int i = 0; i < cells.length; i += 5) {
      weeks.add(cells.sublist(i, i + 5));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: List.generate(weeks.length, (wi) {
          final week = weeks[wi];
          final realDays = week.where((c) => !c.isEmpty).toList();
          if (realDays.isEmpty) return const SizedBox();

          return Row(
            children: List.generate(5, (di) {
              final c = di < realDays.length ? realDays[di] : null;
              if (c == null) {
                return Expanded(
                  child: Container(
                    height: 52,
                    color: isDark
                        ? (wi.isEven ? const Color(0xFF161B22) : const Color(0xFF1A1F2E))
                        : (wi.isEven ? Colors.white : const Color(0xFFF9FAFB)),
                  ),
                );
              }
              return Expanded(
                child: CalendarCard(
                  date: c.date, twod: c.twod, offDay: c.offDay, month: c.month,
                  layoutHint: CalendarLayout.compactTable,
                  rowIndex: wi,
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 4 — Week Strip  (horizontal scrollable weeks, card per day large)
// ═════════════════════════════════════════════════════════════════════════════
class _WeekStripLayout extends StatelessWidget {
  final List<_CellData> cells;
  const _WeekStripLayout({required this.cells});

  @override
  Widget build(BuildContext context) {
    final weeks = <List<_CellData>>[];
    for (int i = 0; i < cells.length; i += 5) {
      weeks.add(cells.sublist(i, i + 5));
    }

    return Column(
      children: List.generate(weeks.length, (wi) {
        final week = weeks[wi];
        final realDays = week.where((c) => !c.isEmpty).toList();
        if (realDays.isEmpty) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: List.generate(5, (di) {
              if (di >= realDays.length) {
                return const Expanded(child: SizedBox());
              }
              final c = realDays[di];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: di < 4 ? 6 : 0),
                  child: CalendarCard(
                    date: c.date, twod: c.twod, offDay: c.offDay, month: c.month,
                    layoutHint: CalendarLayout.weekStrip,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 5 — Spot Grid  (tight 5×5, large number focus, minimal chrome)
// ═════════════════════════════════════════════════════════════════════════════
class _SpotGridLayout extends StatelessWidget {
  final List<_CellData> cells;
  const _SpotGridLayout({required this.cells});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 25,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (_, i) {
        final c = cells[i];
        if (c.isEmpty) return const SizedBox();
        return CalendarCard(
          date: c.date, twod: c.twod, offDay: c.offDay, month: c.month,
          layoutHint: CalendarLayout.spotGrid,
        );
      },
    );
  }
}
