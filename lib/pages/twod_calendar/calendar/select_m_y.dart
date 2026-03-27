import 'package:go_router/go_router.dart';
import '../../home/widgets/live_helper.dart';
import '../../../utils/extension.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class SelectMY extends StatefulWidget {
  final DateTime? dateTime;
  const SelectMY({super.key, this.dateTime});

  @override
  State<SelectMY> createState() => _SelectMYState();
}

class _SelectMYState extends State<SelectMY> with TickerProviderStateMixin {
  int? mIndex;
  int yIndex = LiveHelper.yrs.length - 1;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _scaleAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack));
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animCtrl.forward();
      if (widget.dateTime != null) {
        final dt = widget.dateTime!;
        setState(() {
          mIndex = dt.month - 1;
          final idx = LiveHelper.yrs.indexOf('${dt.year}');
          if (idx != -1) yIndex = idx;
        });
      }
    });
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

    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (_, __) => Transform.scale(
        scale: _scaleAnim.value,
        child: Opacity(
          opacity: _fadeAnim.value,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(primary),
                  _buildMonthGrid(isDark, primary),
                  _buildActions(context, isDark, primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header with year selector
  Widget _buildHeader(Color primary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, Color.lerp(primary, Colors.black, 0.3)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Select Month & Year",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Year row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _yearBtn(
                  icon: Icons.chevron_left_rounded,
                  onTap: yIndex > 0 ? () => setState(() => yIndex--) : null,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Text(
                    LiveHelper.yrs[yIndex],
                    key: ValueKey(yIndex),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                _yearBtn(
                  icon: Icons.chevron_right_rounded,
                  onTap: yIndex < LiveHelper.yrs.length - 1
                      ? () => setState(() => yIndex++)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _yearBtn({required IconData icon, required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: onTap != null
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: onTap != null ? Colors.white : Colors.white30,
          size: 26,
        ),
      ),
    );
  }

  // ── Month grid
  Widget _buildMonthGrid(bool isDark, Color primary) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: LiveHelper.months.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (_, i) => _monthTile(i, isDark, primary),
      ),
    );
  }

  Widget _monthTile(int i, bool isDark, Color primary) {
    final isSelected = i == mIndex;
    final isNow =
        DateTime.now().month - 1 == i &&
        int.parse(LiveHelper.yrs[yIndex]) == DateTime.now().year;

    return GestureDetector(
      onTap: () => setState(() => mIndex = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.indigo
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? primary
                : isNow
                ? primary.withValues(alpha: 0.4)
                : isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.shade200,
            width: isSelected ? 0 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              LiveHelper.months[i],
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isDark
                    ? Colors.white70
                    : AppColors.textMid,
              ),
            ),
            if (isNow && !isSelected)
              Positioned(
                top: 5,
                right: 6,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Action buttons
  Widget _buildActions(BuildContext context, bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          // Cancel
          Expanded(
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Confirm
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: mIndex == null
                  ? null
                  : () {
                      final m = '${mIndex! + 1}'.padLeft(2, '0');
                      final y = LiveHelper.yrs[yIndex];
                      Navigator.pop(context, DateTime.parse('$y-$m-01'));
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: mIndex != null ? Colors.green : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: mIndex != null
                      ? [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    const Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
