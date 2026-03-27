import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/localization/app_lang.dart';
import '../../config/localization/localization.dart';
import '../../utils/extension.dart';
import '../../utils/images.dart';
import '../../utils/app_colors.dart';

class Language extends StatefulWidget {
  final bool? showBack;
  const Language({super.key, this.showBack});

  @override
  State<StatefulWidget> createState() => _LanguageState();
}

class _LanguageState extends State<Language>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = context.colors.primary;

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.language.tr())),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Current language badge
                _currentLangCard(isDark, primary),
                const SizedBox(height: 20),

                // ── Section label
                _sectionLabel("Available Languages", isDark, primary),
                const SizedBox(height: 10),

                // ── Language list card
                _buildCard(
                  isDark: isDark,
                  child: Column(
                    children: List.generate(AppLang.supportedLocale.length, (
                      i,
                    ) {
                      final locale = AppLang.supportedLocale[i];
                      final isLast = i == AppLang.supportedLocale.length - 1;
                      return Column(
                        children: [
                          _LangTile(
                            locale: locale,
                            isDark: isDark,
                            primary: primary,
                            isSelected:
                                context.locale.languageCode ==
                                locale.languageCode,
                            onTap: () {
                              if (context.locale.languageCode !=
                                  locale.languageCode) {
                                HapticFeedback.lightImpact();
                                context.setLocale(locale);
                              }
                            },
                          ),
                          if (!isLast)
                            Divider(
                              height: 1,
                              indent: 70,
                              endIndent: 16,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.grey.shade100,
                            ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Info note
                _infoCard(
                  isDark: isDark,
                  primary: primary,
                  text:
                      'The app will restart automatically when you change the language.',
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _currentLangCard(bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.translate_rounded, color: primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Language',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
                Text(
                  AppLang.supportedLanguages[context.locale.languageCode] ??
                      "Unknown",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              context.locale.countryCode == "MM" ? Imgs.mmFlag : Imgs.ukFlag,
              width: 32,
              height: 24,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, bool isDark, Color primary) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: isDark ? Colors.white54 : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required bool isDark, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoCard({
    required bool isDark,
    required Color primary,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : primary.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Language tile
class _LangTile extends StatelessWidget {
  final Locale locale;
  final bool isDark;
  final Color primary;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangTile({
    required this.locale,
    required this.isDark,
    required this.primary,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = AppLang.supportedLanguages[locale.languageCode] ?? "Unknown";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Flag
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.shade200,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  locale.countryCode == "MM" ? Imgs.mmFlag : Imgs.ukFlag,
                  width: 28,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primary : null,
                    ),
                  ),
                  Text(
                    locale.languageCode.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            // Check indicator
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isSelected
                  ? Container(
                      key: const ValueKey('on'),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : Container(
                      key: const ValueKey('off'),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
