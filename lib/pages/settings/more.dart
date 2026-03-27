import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_lion/admob/ad_helper.dart';
import 'package:new_lion/utils/fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../config/localization/localization.dart';
import '../../config/routes/route_locations.dart';
import '../../utils/const.dart';
import '../../utils/extension.dart';
import '../../utils/global.dart';
import '../../utils/reusable.dart';
import '../../utils/app_colors.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

class _MenuItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final String route;
  final bool showAd;
  final bool isExternal;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.route,
    this.showAd = false,
    this.isExternal = false,
  });
}

class _Section {
  final String label;
  final List<_MenuItem> items;
  const _Section({required this.label, required this.items});
}

// ── Page ──────────────────────────────────────────────────────────────────────

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  late final List<_Section> _sections;

  @override
  void initState() {
    super.initState();
    _sections = [
      _Section(label: 'Menu', items: const [
        _MenuItem(
          icon: Icons.bar_chart_rounded,
          label: 'သုံးသပ်ချက်များ',
          subtitle: 'Analysis',
          color: AppColors.info,
          route: RouteLocation.analysis,
          showAd: true,
        ),
        
        _MenuItem(
          icon: Icons.emoji_events_rounded,
          label: 'ထိုင်းထီပေါက်စဉ်',
          subtitle: 'Thai Lotto',
          color: AppColors.error,
          route: RouteLocation.lottoThai,
          showAd: true,
        ),
        _MenuItem(
          icon: Icons.bedtime_rounded,
          label: 'အိမ်မက် တစ်ထောင်',
          subtitle: 'Dream Book',
          color: AppColors.indigo,
          route: RouteLocation.dream,
          showAd: true,
        ),
        _MenuItem(
          icon: Icons.event_busy_rounded,
          label: '2D ပိတ်ရက်များ',
          subtitle: 'Closed Days',
          color: AppColors.warning,
          route: RouteLocation.setHolidays,
        ),
      ]),
      _Section(label: 'Account', items: [
        _MenuItem(
          icon: Icons.person_rounded,
          label: 'Account',
          subtitle: Global.user?.email ?? 'Manage your account',
          color: Colors.indigo,
          route: RouteLocation.updateProfile,
        ),
        _MenuItem(
          icon: Icons.block_rounded,
          label: 'Block List',
          subtitle: 'Manage blocked users',
          color: AppColors.error,
          route: RouteLocation.blockList,
        ),
      ]),
      _Section(label: 'Other', items: [
        _MenuItem(
          icon: Icons.settings_rounded,
          label: LocaleKeys.setting.tr(),
          subtitle: 'App settings',
          color: AppColors.success,
          route: RouteLocation.setting,
        ),
        _MenuItem(
          icon: Icons.star_rounded,
          label: 'Rate Us',
          subtitle: 'Enjoying the app? Leave a review!',
          color: Colors.amber,
          route: '',
          isExternal: true,
        ),
        
      ]),
    ];
  }

  void _onTap(BuildContext context, _MenuItem item) async {
    // Rate Us — external
    if (item.isExternal) {
      final info = await PackageInfo.fromPlatform();
      Reusable.openURL('${Const.playstoreURL}?id=${info.packageName}');
      return;
    }

    // Auth guard
    final authRoutes = [RouteLocation.updateProfile, RouteLocation.blockList];
    if (authRoutes.contains(item.route) && Global.user == null) {
      context.pushNamed(RouteLocation.login);
      return;
    }

    if (item.showAd) {
      AdHelper.showInterstitialAd(
        onComplete: () => context.pushNamed(item.route),
      );
    } else {
      context.pushNamed(item.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.others.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _sections
              .map((s) => _AccentSection(
                    section: s,
                    isDark: isDark,
                    onTap: (item) => _onTap(context, item),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── Section ───────────────────────────────────────────────────────────────────

class _AccentSection extends StatelessWidget {
  final _Section section;
  final bool isDark;
  final void Function(_MenuItem) onTap;

  const _AccentSection({
    required this.section,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 10),
            child: Text(
              section.label.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.35)
                    : Colors.grey.shade500,
              ),
            ),
          ),

          // Rows
          Column(
            children: section.items
                .map((item) => _AccentRow(
                      item: item,
                      isDark: isDark,
                      onTap: () => onTap(item),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Accent Row ────────────────────────────────────────────────────────────────

class _AccentRow extends StatelessWidget {
  final _MenuItem item;
  final bool isDark;
  final VoidCallback onTap;

  const _AccentRow({
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.grey.shade50,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.grey.shade200,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        foregroundDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: item.color, width: 3),
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(item.icon, color: item.color, size: 18),
              ),
              const SizedBox(width: 12),

              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: Fonts.umoe,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing
              Icon(
                item.isExternal
                    ? Icons.open_in_new_rounded
                    : Icons.chevron_right_rounded,
                size: 18,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.25)
                    : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}