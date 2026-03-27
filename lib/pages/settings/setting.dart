import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/localization/app_lang.dart';
import '../../config/localization/localization.dart';
import '../../utils/const.dart';
import '../../utils/extension.dart';
import '../../utils/global.dart';
import '../../utils/images.dart';
import '../../utils/shared_pref.dart';
import '../../widgets/setting_widgets.dart';
import '../../utils/app_colors.dart';

final settingPageStateKey = GlobalKey<_SettingState>();

// ── Local constants ───────────────────────────────────────────────────────────

const _kDotSize         = 24.0;
const _kToggleWidth     = 50.0;
const _kToggleHeight    = 28.0;
const _kToggleThumbSize = 24.0;

const _kNotiOnColor  = AppColors.success;
const _kNotiOffColor = AppColors.error;

// ── Page ──────────────────────────────────────────────────────────────────────

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final isDark  = context.isDarkMode;
    final primary = context.colors.primary;

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.setting.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingSection(
              isDark: isDark,
              label: 'Appearance',
              child: SettingRow(
                isDark: isDark,
                showDivider: false,
                leading: SettingIconBox(
                  icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: Colors.indigo,
                ),
                title: LocaleKeys.nightMode.tr(),
                subtitle: isDark ? 'Dark mode is on' : 'Light mode is on',
                trailing: _ThemeToggle(primary: primary),
              ),
            ),

            kSectionSpacing,

            SettingSection(
              isDark: isDark,
              label: LocaleKeys.language.tr(),
              child: _buildLanguageList(isDark: isDark, primary: primary),
            ),

            kSectionSpacing,

            SettingSection(
              isDark: isDark,
              label: LocaleKeys.noti.tr(),
              child: _buildNotificationList(isDark: isDark, primary: primary),
            ),

            kSectionSpacing,
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageList({required bool isDark, required Color primary}) {
    final locales = AppLang.supportedLocale;
    return Column(
      children: List.generate(locales.length, (i) {
        final locale     = locales[i];
        final isSelected = context.locale.languageCode == locale.languageCode;
        final name       = AppLang.supportedLanguages[locale.languageCode] ?? '';
        return _LangTile(
          locale: locale,
          name: name,
          isSelected: isSelected,
          showDivider: i < locales.length - 1,
          isDark: isDark,
          primary: primary,
          onTap: isSelected
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  context.setLocale(locale);
                },
        );
      }),
    );
  }

  Widget _buildNotificationList({required bool isDark, required Color primary}) {
    return ValueListenableBuilder<bool>(
      valueListenable: Global.notiStatus,
      builder: (_, status, __) => Column(
        children: [
          _NotiTile(
            isDark: isDark,
            primary: primary,
            icon: Icons.notifications_active_rounded,
            iconColor: _kNotiOnColor,
            title: LocaleKeys.on.tr(),
            subtitle: 'Receive all notifications',
            isActive: status,
            showDivider: true,
            onTap: status
                ? null
                : () {
                    Global.notiStatus.value = true;
                    SharedPref.clearData(key: Const.notiStatus);
                  },
          ),
          _NotiTile(
            isDark: isDark,
            primary: primary,
            icon: Icons.notifications_off_rounded,
            iconColor: _kNotiOffColor,
            title: LocaleKeys.off.tr(),
            subtitle: 'Turn off all notifications',
            isActive: !status,
            showDivider: false,
            onTap: !status
                ? null
                : () {
                    Global.notiStatus.value = false;
                    SharedPref.setData(key: Const.notiStatus, value: 'off');
                  },
          ),
        ],
      ),
    );
  }
}

// ── Selection dot ─────────────────────────────────────────────────────────────

class _SelectionDot extends StatelessWidget {
  final bool isActive;
  final Color primary;
  final bool isDark;
  final double size;

  const _SelectionDot({
    required this.isActive,
    required this.primary,
    required this.isDark,
    this.size = _kDotSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 230),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? primary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive
              ? primary
              : isDark ? Colors.white24 : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: isActive
          ? Icon(Icons.check_rounded, color: Colors.white, size: size * 0.6)
          : null,
    );
  }
}

// ── Language tile ─────────────────────────────────────────────────────────────

class _LangTile extends StatelessWidget {
  final Locale locale;
  final String name;
  final bool isSelected;
  final bool showDivider;
  final bool isDark;
  final Color primary;
  final VoidCallback? onTap;

  const _LangTile({
    required this.locale,
    required this.name,
    required this.isSelected,
    required this.showDivider,
    required this.isDark,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: kTilePadding,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    locale.countryCode == 'MM' ? Imgs.mmFlag : Imgs.ukFlag,
                    width: kIconBoxSize,
                    height: 28,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        locale.languageCode.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                _SelectionDot(isActive: isSelected, primary: primary, isDark: isDark),
              ],
            ),
          ),
        ),
        if (showDivider) TileDivider(isDark: isDark),
      ],
    );
  }
}

// ── Notification tile ─────────────────────────────────────────────────────────

class _NotiTile extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isActive;
  final bool showDivider;
  final VoidCallback? onTap;

  const _NotiTile({
    required this.isDark,
    required this.primary,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: kTilePadding,
            child: Row(
              children: [
                _NotiIconBox(isDark: isDark, icon: icon, iconColor: iconColor, isActive: isActive),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? null
                              : (isDark ? Colors.white38 : Colors.grey.shade400),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                _SelectionDot(isActive: isActive, primary: primary, isDark: isDark, size: 22),
              ],
            ),
          ),
        ),
        if (showDivider) TileDivider(isDark: isDark),
      ],
    );
  }
}

// ── Notification icon box ─────────────────────────────────────────────────────

class _NotiIconBox extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final bool isActive;

  const _NotiIconBox({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: kIconBoxSize,
      height: kIconBoxSize,
      decoration: BoxDecoration(
        color: isActive
            ? iconColor.withValues(alpha: 0.12)
            : isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(kIconBoxRadius),
      ),
      child: Icon(icon, size: 20, color: isActive ? iconColor : Colors.grey.shade400),
    );
  }
}

// ── Theme toggle ──────────────────────────────────────────────────────────────

class _ThemeToggle extends StatelessWidget {
  final Color primary;

  const _ThemeToggle({required this.primary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => AdaptiveTheme.of(context).toggleThemeMode(useSystem: false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        width: _kToggleWidth,
        height: _kToggleHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kToggleHeight / 2),
          color: isDark ? Colors.grey.shade300 : Colors.grey.shade200,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              left: isDark ? _kToggleWidth - _kToggleThumbSize - 2 : 2,
              top: 2,
              child: Container(
                width: _kToggleThumbSize,
                height: _kToggleThumbSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(_kToggleThumbSize / 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 14,
                  color: isDark ? primary : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}