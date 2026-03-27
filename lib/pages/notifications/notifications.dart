import 'package:flutter/material.dart';
import '../../config/localization/localization.dart';
import '../../utils/const.dart';
import '../../utils/extension.dart';
import '../../utils/global.dart';
import '../../utils/shared_pref.dart';
import '../../utils/app_colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationState();
}

class _NotificationState extends State<Notifications>
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
      appBar: AppBar(title: Text(LocaleKeys.noti.tr())),
      body: ValueListenableBuilder(
        valueListenable: Global.notiStatus,
        builder: (ctx, status, _) {
          return FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Status card
                    _statusCard(isDark, primary, status),
                    const SizedBox(height: 20),

                    // ── Options
                    _sectionLabel("Choose your preference", isDark, primary),
                    const SizedBox(height: 10),
                    _buildCard(
                      isDark: isDark,
                      child: Column(
                        children: [
                          _NotiOption(
                            title: LocaleKeys.on.tr(),
                            subtitle: 'Receive all app notifications',
                            icon: Icons.notifications_active_rounded,
                            iconColor: AppColors.success,
                            isActive: status,
                            isDark: isDark,
                            primary: primary,
                            showDivider: true,
                            onTap: () {
                              if (!status) {
                                Global.notiStatus.value = true;
                                SharedPref.clearData(key: Const.notiStatus);
                              }
                            },
                          ),
                          _NotiOption(
                            title: LocaleKeys.off.tr(),
                            subtitle: 'Turn off all notifications',
                            icon: Icons.notifications_off_rounded,
                            iconColor: AppColors.error,
                            isActive: !status,
                            isDark: isDark,
                            primary: primary,
                            showDivider: false,
                            onTap: () {
                              if (status) {
                                Global.notiStatus.value = false;
                                SharedPref.setData(
                                  key: Const.notiStatus,
                                  value: "off",
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Info note
                    _infoCard(isDark, primary),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusCard(bool isDark, Color primary, bool status) {
    final color = status ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.12 : 0.08),
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
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              status
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status ? 'Notifications Enabled' : 'Notifications Disabled',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  status
                      ? 'You will receive app notifications'
                      : 'You won\'t receive any notifications',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          // Live dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6),
              ],
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

  Widget _infoCard(bool isDark, Color primary) {
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
              'Changes take effect immediately. You can always modify these settings later.',
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

// ── Notification option tile
class _NotiOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isActive;
  final bool isDark;
  final Color primary;
  final bool showDivider;
  final VoidCallback onTap;

  const _NotiOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isActive,
    required this.isDark,
    required this.primary,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive
                        ? iconColor.withValues(alpha: 0.12)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.grey.shade50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isActive ? iconColor : Colors.grey.shade400,
                    size: 20,
                  ),
                ),
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
                          color: isActive ? null : Colors.grey,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Radio indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isActive ? primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? primary : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  child: isActive
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 14,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
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
  }
}
