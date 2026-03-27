import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import '../../../data/models/stock_model.dart';
import '../../home/widgets/live_helper.dart';
import 'twod_info.dart';
import 'calendar_body.dart';
import '../../../widgets/easy_overlay/easy_overlay.dart';
import '../../../utils/extension.dart';
import '../../../utils/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CalendarCard — renders differently per layout hint
// ─────────────────────────────────────────────────────────────────────────────
class CalendarCard extends StatefulWidget {
  final StockModel? twod;
  final bool offDay;
  final String date;
  final DateTime month;
  final CalendarLayout layoutHint;
  final bool isLastInGroup;
  final int rowIndex;

  const CalendarCard({
    super.key,
    required this.month,
    required this.date,
    required this.twod,
    required this.offDay,
    this.layoutHint = CalendarLayout.gridClassic,
    this.isLastInGroup = false,
    this.rowIndex = 0,
  });

  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  bool _pressed = false;

  void _onTap() {
    if (widget.twod == null) return;
    EasyOverlay.show(child: TwodInfo(twod: widget.twod!));
  }

  bool get _isToday {
    final now = DateTime.now();
    final d = DateTime(
      widget.month.year,
      widget.month.month,
      int.parse(widget.date),
    );
    return now.year == d.year && now.month == d.month && now.day == d.day;
  }

  List<String> get _results {
    if (widget.twod == null) return [];
    final r1 = LiveHelper.getResult(
      setNum: widget.twod!.round1?.set,
      valueNum: widget.twod!.round1?.value,
    );
    final r2 = LiveHelper.getResult(
      setNum: widget.twod!.round2?.set,
      valueNum: widget.twod!.round2?.value,
    );
    return [if (r1.isNotEmpty) r1, if (r2.isNotEmpty) r2];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.date == '00') return const SizedBox();

    final isDark = AdaptiveTheme.of(context).mode.isDark;
    final primary = context.colors.primary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: _onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: _build(isDark, primary),
      ),
    );
  }

  Widget _build(bool isDark, Color primary) {
    switch (widget.layoutHint) {
      case CalendarLayout.gridClassic:
        return _buildGridClassic(isDark, primary);
      case CalendarLayout.timeline:
        return _buildTimeline(isDark, primary);
      case CalendarLayout.compactTable:
        return _buildCompactTable(isDark, primary);
      case CalendarLayout.weekStrip:
        return _buildWeekStrip(isDark, primary);
      case CalendarLayout.spotGrid:
        return _buildSpotGrid(isDark, primary);
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // LAYOUT 1 — Grid Classic
  // Plain grid card: colored top strip + result number in body
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildGridClassic(bool isDark, Color primary) {
    final results = _results;
    final isToday = _isToday;
    final hasData = widget.twod != null;

    Color bg, border, strip;

    if (widget.offDay) {
      bg = isDark ? AppColors.calRedDark : AppColors.calRedLight;
      border = Colors.red.shade400;
      strip = Colors.red.shade500;
    } else if (isToday) {
      bg = isDark ? AppColors.calAmberDark : AppColors.calAmberLight;
      border = Colors.amber.shade500;
      strip = Colors.amber.shade600;
    } else if (hasData) {
      bg = isDark
          ? primary.withValues(alpha: 0.18)
          : primary.withValues(alpha: 0.06);
      border = primary.withValues(alpha: isDark ? 0.5 : 0.3);
      strip = primary;
    } else {
      bg = isDark ? AppColors.darkCard5 : Colors.white;
      border = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.grey.shade200;
      strip = isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.grey.shade400;
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: isToday ? 1.5 : 1),
        boxShadow: (isToday || hasData)
            ? [
                BoxShadow(
                  color: border.withValues(alpha: isDark ? 0.25 : 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: strip,
              child: Text(
                widget.date,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
            Expanded(child: _gridClassicContent(isDark, primary, results)),
          ],
        ),
      ),
    );
  }

  Widget _gridClassicContent(bool isDark, Color primary, List<String> results) {
    if (widget.offDay) {
      return Center(
        child: Icon(Icons.block_rounded, size: 20, color: Colors.red.shade400),
      );
    }
    if (results.isEmpty) {
      return Center(
        child: Text(
          '—',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: results
          .map(
            (r) => Text(
              r,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: results.length == 1 ? 17 : 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : primary,
                height: 1.15,
              ),
            ),
          )
          .toList(),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // LAYOUT 2 — Timeline
  // Full-width row: date circle left | result right | divider between rows
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildTimeline(bool isDark, Color primary) {
    final results = _results;
    final isToday = _isToday;

    final dotColor = widget.offDay
        ? Colors.red.shade400
        : isToday
        ? Colors.amber.shade500
        : results.isNotEmpty
        ? primary
        : (isDark ? Colors.white24 : Colors.grey.shade300);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              // ── Date circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor.withValues(alpha: isDark ? 0.18 : 0.1),
                  border: Border.all(
                    color: dotColor.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.date,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : dotColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // ── Day name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _weekdayName(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white38 : Colors.grey.shade400,
                      ),
                    ),
                    if (widget.offDay)
                      Text(
                        'Off Day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade400,
                        ),
                      ),
                  ],
                ),
              ),
              // ── Results right side
              if (results.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: results
                      .map(
                        (r) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          margin: const EdgeInsets.only(bottom: 2),
                          decoration: BoxDecoration(
                            color: primary.withValues(
                              alpha: isDark ? 0.2 : 0.08,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            r,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : primary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              else if (widget.offDay)
                Icon(
                  Icons.event_busy_rounded,
                  color: Colors.red.shade300,
                  size: 22,
                )
              else
                Text(
                  '—',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                  ),
                ),
            ],
          ),
        ),
        if (!widget.isLastInGroup)
          Divider(
            height: 1,
            indent: 68,
            endIndent: 14,
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.grey.shade100,
          ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // LAYOUT 3 — Compact Table
  // Spreadsheet-style: alternating row bg, date small top-left, number centered big
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildCompactTable(bool isDark, Color primary) {
    final results = _results;
    final isToday = _isToday;

    final rowBg = widget.offDay
        ? (isDark
              ? AppColors.calRedDark.withValues(alpha: 0.6)
              : const Color(0xFFFEF2F2))
        : isToday
        ? primary.withValues(alpha: isDark ? 0.2 : 0.07)
        : widget.rowIndex.isEven
        ? (isDark ? const Color(0xFF161B22) : Colors.white)
        : (isDark ? const Color(0xFF1A1F2E) : const Color(0xFFF9FAFB));

    return Container(
      height: 52,
      color: rowBg,
      child: Stack(
        children: [
          // Date badge top-left
          Positioned(
            top: 4,
            left: 5,
            child: Text(
              widget.date,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isToday
                    ? primary
                    : widget.offDay
                    ? Colors.red.shade400
                    : isDark
                    ? Colors.white24
                    : Colors.grey.shade300,
              ),
            ),
          ),
          // Result center
          Center(
            child: widget.offDay
                ? Icon(
                    Icons.block_rounded,
                    size: 16,
                    color: Colors.red.shade300,
                  )
                : results.isEmpty
                ? Text(
                    '·',
                    style: TextStyle(
                      fontSize: 20,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.grey.shade200,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: results
                        .map(
                          (r) => Text(
                            r,
                            style: TextStyle(
                              fontSize: results.length == 1 ? 17 : 13,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              color: isToday
                                  ? primary
                                  : isDark
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : const Color(0xFF111827),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          // Right border
          Positioned(
            right: 0,
            top: 6,
            bottom: 6,
            child: Container(
              width: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // LAYOUT 4 — Week Strip
  // Tall cards per day with weekday label, pill result badge, soft shadow
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildWeekStrip(bool isDark, Color primary) {
    final results = _results;
    final isToday = _isToday;

    Color bg, accent;
    if (widget.offDay) {
      bg = isDark ? const Color(0xFF2A1515) : const Color(0xFFFEF2F2);
      accent = Colors.red.shade400;
    } else if (isToday) {
      bg = primary;
      accent = Colors.white;
    } else if (results.isNotEmpty) {
      bg = isDark ? const Color(0xFF1A1F2E) : Colors.white;
      accent = primary;
    } else {
      bg = isDark ? const Color(0xFF161B22) : const Color(0xFFF9FAFB);
      accent = isDark ? Colors.white24 : Colors.grey.shade300;
    }

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: !isToday
            ? Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.grey.shade100,
              )
            : null,
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: primary.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : results.isNotEmpty
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Weekday abbrev
          Text(
            _weekdayShort(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isToday
                  ? Colors.white.withValues(alpha: 0.7)
                  : isDark
                  ? Colors.white30
                  : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 3),
          // Date
          Text(
            widget.date,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isToday ? Colors.white : accent,
            ),
          ),
          const SizedBox(height: 4),
          // Result pill or off indicator
          if (widget.offDay)
            Icon(
              Icons.block_rounded,
              size: 14,
              color: isToday ? Colors.white70 : Colors.red.shade300,
            )
          else if (results.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isToday
                    ? Colors.white.withValues(alpha: 0.25)
                    : primary.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                results.first,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: isToday ? Colors.white : primary,
                ),
              ),
            )
          else
            Container(
              width: 16,
              height: 2,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // LAYOUT 5 — Spot Grid
  // Minimal circle/spot per day: large number, no strip, accent dot for today
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildSpotGrid(bool isDark, Color primary) {
    final results = _results;
    final isToday = _isToday;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.offDay
            ? (isDark ? AppColors.calRedDark : AppColors.calRedLight)
            : isToday
            ? primary
            : results.isNotEmpty
            ? (primary.withValues(alpha: isDark ? 1 : 0.15))
            : (isDark
                  ? const Color(0xFF161B22)
                  : primary.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? null
            : Border.all(color: primary.withValues(alpha: isDark ? 0.3 : 0.15)),
        boxShadow: isToday
            ? [BoxShadow(color: primary.withValues(alpha: 0.4), blurRadius: 10)]
            : null,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Text(
              widget.date,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: widget.offDay
                  ? Icon(
                      Icons.block_rounded,
                      size: 18,
                      color: isDark ? Colors.red.shade300 : Colors.red,
                    )
                  : results.isEmpty
                  ? SizedBox()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: results
                          .map(
                            (r) => Text(
                              r,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                color: isToday
                                    ? Colors.white
                                    : isDark
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : primary,
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  String _weekdayName() {
    try {
      final d = DateTime(
        widget.month.year,
        widget.month.month,
        int.parse(widget.date),
      );
      const names = [
        '',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return names[d.weekday];
    } catch (_) {
      return '';
    }
  }

  String _weekdayShort() {
    try {
      final d = DateTime(
        widget.month.year,
        widget.month.month,
        int.parse(widget.date),
      );
      const names = ['', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
      return names[d.weekday];
    } catch (_) {
      return '';
    }
  }
}
