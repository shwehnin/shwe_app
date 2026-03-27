import 'package:flutter/material.dart';
import '../../config/localization/localization.dart';
import '../../utils/extension.dart';
import '../../utils/global.dart';
import '../../utils/reusable.dart';
import '../../utils/app_colors.dart';

class SetHolidays extends StatefulWidget {
  const SetHolidays({super.key});

  @override
  State<StatefulWidget> createState() => _SetHolidaysState();
}

class _SetHolidaysState extends State<SetHolidays>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  int _nextHolidayIndex = -1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _findNextHolidayIndex();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNextHoliday());
  }

  void _findNextHolidayIndex() {
    if (Global.config.setHoliday == null || Global.config.setHoliday!.isEmpty) {
      return;
    }
    final now = DateTime.now();
    for (int i = 0; i < Global.config.setHoliday!.length; i++) {
      final date = DateTime.parse(
        '${Global.config.setHoliday![i].date?.split("T")[0]}',
      );
      if (date.isAfter(now)) {
        _nextHolidayIndex = i;
        break;
      }
    }
  }

  void _scrollToNextHoliday() {
    if (_nextHolidayIndex == -1) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        const cardHeight = 88.0;
        const cardMargin = 10.0;
        const topPadding = 16.0;
        final target =
            (topPadding + _nextHolidayIndex * (cardHeight + cardMargin)).clamp(
              0.0,
              _scrollController.position.maxScrollExtent,
            );
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.colors.primary;
    final holidays = Global.config.setHoliday ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.setHoliday.tr())),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: holidays.length,
        itemBuilder: (_, idx) {
          final setM = holidays[idx];
          final date = DateTime.parse('${setM.date?.split("T")[0]}');
          final isUpcoming = date.isAfter(DateTime.now());
          final isNext = idx == _nextHolidayIndex;

          return _HolidayCard(
            index: idx + 1,
            date: date,
            description: setM.description,
            isUpcoming: isUpcoming,
            isNext: isNext,
            isDark: isDark,
            primary: primary,
          );
        },
      ),
    );
  }
}

class _HolidayCard extends StatelessWidget {
  final int index;
  final DateTime date;
  final String? description;
  final bool isUpcoming;
  final bool isNext;
  final bool isDark;
  final Color primary;

  const _HolidayCard({
    required this.index,
    required this.date,
    required this.description,
    required this.isUpcoming,
    required this.isNext,
    required this.isDark,
    required this.primary,
  });

  static const _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  @override
  Widget build(BuildContext context) {
    // Color scheme per state
    final Color accentColor = isUpcoming
        ? AppColors
              .warning // amber — upcoming
        : Colors.grey.shade400; // grey — past

    return Opacity(
      opacity: isUpcoming ? 1.0 : 0.55,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isNext
                ? accentColor.withValues(alpha: 0.5)
                : isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.grey.shade100,
            width: isNext ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isNext
                  ? accentColor.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: isNext ? 14 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // ── Date badge
              Container(
                width: 52,
                height: 60,
                decoration: BoxDecoration(
                  color: isUpcoming
                      ? isDark
                            ? Colors.indigo.withValues(alpha: 0.25)
                            : context.colors.primary
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey.shade50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUpcoming
                        ? Colors.indigo.withValues(alpha: 0.25)
                        : Colors.grey.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        color: isUpcoming
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.grey.shade400),
                      ),
                    ),
                    Text(
                      _months[date.month - 1],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: isUpcoming ? Colors.grey : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // ── Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status chip
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isUpcoming
                                ? accentColor.withValues(alpha: 0.12)
                                : Colors.grey.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: isUpcoming
                                      ? accentColor
                                      : Colors.grey.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isUpcoming ? 'Upcoming' : 'Past',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  color: isUpcoming
                                      ? accentColor
                                      : Colors.grey.shade500,
                                ),
                              ),
                              // "Next" badge
                              if (isNext) ...[
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'NEXT',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Myanmar date
                    Text(
                      Reusable.formatDateToMyanmar(date.toString()),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textDark,
                      ),
                    ),

                    if (description != null && description!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // ── Index number
              Text(
                '$index',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white24 : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
