import 'package:flutter/material.dart';
import '../widgets/easy_overlay/easy_overlay.dart';
import '../utils/app_colors.dart';

class RewarededAlert extends StatelessWidget {
  final VoidCallback watch;
  const RewarededAlert({super.key, required this.watch});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.adDarkBg : Colors.white;
    final textPrimary = isDark ? Colors.white : AppColors.nearBlack;
    final textSub = isDark ? AppColors.adSubDark : AppColors.adSubLight;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.symmetric(horizontal: 36),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.10),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon badge
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? AppColors.adDarkCard : AppColors.adLightCard,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_circle_outline_rounded,
                size: 28,
                color: isDark ? Colors.white70 : AppColors.adTextDark,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              'Watch a short ad',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 6),

            // Subtitle
            Text(
              'Only takes a few seconds to unlock.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: textSub, height: 1.4),
            ),

            const SizedBox(height: 22),

            // Watch button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  EasyOverlay.dismiss();
                  watch();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : AppColors.nearBlack,
                  foregroundColor: isDark ? AppColors.nearBlack : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Watch & Unlock',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Cancel
            TextButton(
              onPressed: () => EasyOverlay.dismiss(),
              style: TextButton.styleFrom(
                foregroundColor: textSub,
                minimumSize: const Size(double.infinity, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Not now', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
