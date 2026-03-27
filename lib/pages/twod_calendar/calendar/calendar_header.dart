import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/stock_model.dart';
import '../../../utils/extension.dart';
import 'calendar_body.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Calendar2D — header adapts automatically to kCalendarLayout
// ─────────────────────────────────────────────────────────────────────────────
class Calendar2D extends StatelessWidget {
  final VoidCallback pre, next, onSelect;
  final DateTime month;
  final List<StockModel> list;

  const Calendar2D({
    super.key,
    required this.onSelect,
    required this.month,
    required this.next,
    required this.pre,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    switch (kCalendarLayout) {
      case CalendarLayout.gridClassic:
        return _GridClassicShell(
          pre: pre,
          next: next,
          month: month,
          onSelect: onSelect,
          list: list,
        );
      case CalendarLayout.timeline:
        return _TimelineShell(
          pre: pre,
          next: next,
          month: month,
          onSelect: onSelect,
          list: list,
        );
      case CalendarLayout.compactTable:
        return _CompactTableShell(
          pre: pre,
          next: next,
          month: month,
          onSelect: onSelect,
          list: list,
        );
      case CalendarLayout.weekStrip:
        return _WeekStripShell(
          pre: pre,
          next: next,
          month: month,
          onSelect: onSelect,
          list: list,
        );
      case CalendarLayout.spotGrid:
        return _SpotGridShell(
          pre: pre,
          next: next,
          month: month,
          onSelect: onSelect,
          list: list,
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared weekday labels
// ─────────────────────────────────────────────────────────────────────────────
const _kWd = [
  {'en': 'MON', 'mm': 'လာ'},
  {'en': 'TUE', 'mm': 'ဂါ'},
  {'en': 'WED', 'mm': 'ဟူး'},
  {'en': 'THU', 'mm': 'ကြာ'},
  {'en': 'FRI', 'mm': 'သော'},
];

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 1 — Grid Classic
// Bold gradient header card + outlined weekday row
// ═════════════════════════════════════════════════════════════════════════════
class _GridClassicShell extends StatelessWidget {
  final VoidCallback pre, next, onSelect;
  final DateTime month;
  final List<StockModel> list;
  const _GridClassicShell({
    required this.pre,
    required this.next,
    required this.month,
    required this.onSelect,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.colors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient header
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary, Color.lerp(primary, Colors.black, 0.28)!],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onSelect,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('MMM').format(month).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('yyyy').format(month),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.75),
                                letterSpacing: 1.5,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.touch_app_rounded,
                                  size: 11,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'tap to change',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  _navBtn(icon: Icons.chevron_left_rounded, onTap: pre),
                  const SizedBox(width: 8),
                  _navBtn(icon: Icons.chevron_right_rounded, onTap: next),
                ],
              ),
            ],
          ),
        ),
        // Weekday row
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: List.generate(
              5,
              (i) => Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: i < 4
                      ? BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.07)
                                  : Colors.grey.shade200,
                            ),
                          ),
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _kWd[i]['en']!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _kWd[i]['mm']!,
                        style: TextStyle(
                          fontSize: 10,
                          color:  Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        CalendarBody(month: month, list: list),
      ],
    );
  }

  Widget _navBtn({required IconData icon, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      );
}

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 2 — Timeline
// Minimal top bar: small month left, progress bar, nav arrows right
// ═════════════════════════════════════════════════════════════════════════════
class _TimelineShell extends StatelessWidget {
  final VoidCallback pre, next, onSelect;
  final DateTime month;
  final List<StockModel> list;
  const _TimelineShell({
    required this.pre,
    required this.next,
    required this.month,
    required this.onSelect,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.colors.primary;
    final progress = month.day / DateTime(month.year, month.month + 1, 0).day;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: onSelect,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM').format(month),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    Text(
                      DateFormat('yyyy').format(month),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.grey.shade400,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: pre,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  size: 28,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: next,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        // Progress bar
        Container(
          height: 3,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        CalendarBody(month: month, list: list),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 3 — Compact Table
// Spreadsheet header: col labels + sticky month badge, sharp corners
// ═════════════════════════════════════════════════════════════════════════════
class _CompactTableShell extends StatelessWidget {
  final VoidCallback pre, next, onSelect;
  final DateTime month;
  final List<StockModel> list;
  const _CompactTableShell({
    required this.pre,
    required this.next,
    required this.month,
    required this.onSelect,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.colors.primary;

    return Column(
      children: [
        // Table header bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F2E) : primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onSelect,
                child: Row(
                  children: [
                    Text(
                      DateFormat('MMM yyyy').format(month).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.unfold_more_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 16,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: pre,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white70,
                    size: 22,
                  ),
                ),
              ),
              GestureDetector(
                onTap: next,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white70,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Column headers
        Row(
          children: _kWd
              .map(
                (d) => Expanded(
                  child: Container(
                    height: 32,
                    color: isDark
                        ? const Color(0xFF161B22)
                        : primary.withValues(alpha: 0.85),
                    child: Center(
                      child: Text(
                        d['en']!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        // Grid
        CalendarBody(month: month, list: list),
        // Bottom rounded border
        Container(
          height: 2,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.grey.shade100,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 4 — Week Strip
// Centered month title, dot weekday labels below, week-by-week rows
// ═════════════════════════════════════════════════════════════════════════════
class _WeekStripShell extends StatelessWidget {
  final VoidCallback pre, next, onSelect;
  final DateTime month;
  final List<StockModel> list;
  const _WeekStripShell({
    required this.pre,
    required this.next,
    required this.month,
    required this.onSelect,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.colors.primary;

    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _circleBtn(
              icon: Icons.chevron_left_rounded,
              onTap: pre,
              isDark: isDark,
              primary: primary,
            ),
            GestureDetector(
              onTap: onSelect,
              child: Column(
                children: [
                  Text(
                    DateFormat('MMMM').format(month),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  Text(
                    DateFormat('yyyy').format(month),
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 2,
                      color: isDark ? Colors.white30 : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            _circleBtn(
              icon: Icons.chevron_right_rounded,
              onTap: next,
              isDark: isDark,
              primary: primary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Weekday dots
        Row(
          children: _kWd
              .map(
                (d) => Expanded(
                  child: Column(
                    children: [
                      Text(
                        d['mm']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white30 : Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        d['en']!,
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 0.5,
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        CalendarBody(month: month, list: list),
      ],
    );
  }

  Widget _circleBtn({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    required Color primary,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : primary.withValues(alpha: 0.08),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : primary.withValues(alpha: 0.2),
        ),
      ),
      child: Icon(icon, color: isDark ? Colors.white54 : primary, size: 22),
    ),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// LAYOUT 5 — Spot Grid
// Dark full-bleed header, Burmese weekday centered, no extra chrome
// ═════════════════════════════════════════════════════════════════════════════
class _SpotGridShell extends StatelessWidget {
  final VoidCallback pre, next, onSelect;
  final DateTime month;
  final List<StockModel> list;
  const _SpotGridShell({
    required this.pre,
    required this.next,
    required this.month,
    required this.onSelect,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.colors.primary;

    return Column(
      children: [
        // Full-bleed dark header
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: pre,
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white54,
                  size: 28,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onSelect,
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MMM').format(month).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy').format(month),
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 3,
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: next,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white54,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        // Burmese weekday row
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: _kWd
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d['mm']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color:  Colors.grey,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        CalendarBody(month: month, list: list),
      ],
    );
  }
}
