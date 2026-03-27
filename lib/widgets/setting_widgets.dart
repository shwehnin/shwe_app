import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/extension.dart';

// ── Shared constants ──────────────────────────────────────────────────────────

const kSectionRadius = 16.0;
const kIconBoxSize = 40.0;
const kIconBoxRadius = 12.0;
const kTileIndent = 70.0;
const kTilePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 13);
const kSectionSpacing = SizedBox(height: 20);
const kChevronSize = 20.0;

// ── Section card container ────────────────────────────────────────────────────

class SectionCard extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const SectionCard({super.key, required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(kSectionRadius),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kSectionRadius),
        child: child,
      ),
    );
  }
}

// ── Section wrapper with label ────────────────────────────────────────────────

class SettingSection extends StatelessWidget {
  final bool isDark;
  final String label;
  final Widget child;

  const SettingSection({
    super.key,
    required this.isDark,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 13,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        SectionCard(isDark: isDark, child: child),
      ],
    );
  }
}

// ── Generic setting row ───────────────────────────────────────────────────────

class SettingRow extends StatelessWidget {
  final bool isDark;
  final bool showDivider;
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const SettingRow({
    super.key,
    required this.isDark,
    required this.showDivider,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
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
                leading,
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: kTileIndent,
            endIndent: 0,
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.grey.shade100,
          ),
      ],
    );
  }
}

// ── Icon box ──────────────────────────────────────────────────────────────────

class SettingIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const SettingIconBox({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIconBoxSize,
      height: kIconBoxSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(kIconBoxRadius),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}

// ── Chevron trailing icon ─────────────────────────────────────────────────────

class ChevronIcon extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final double size;

  const ChevronIcon({
    super.key,
    required this.isDark,
    this.icon = Icons.chevron_right_rounded,
    this.size = kChevronSize,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: isDark ? Colors.white24 : Colors.grey.shade400,
    );
  }
}

// ── Tile divider ──────────────────────────────────────────────────────────────

class TileDivider extends StatelessWidget {
  final bool isDark;

  const TileDivider({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: kTileIndent,
      endIndent: 0,
      color: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.grey.shade100,
    );
  }
}
