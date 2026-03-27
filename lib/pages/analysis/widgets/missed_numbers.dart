import 'package:flutter/material.dart';
import '../../../config/localization/localization.dart';
import '../../../data/models/miss_model.dart';
import '../../../utils/extension.dart';

class MinimalistMissedNumbers extends StatelessWidget {
  final MissModel miss;
  const MinimalistMissedNumbers({super.key, required this.miss});

  @override
  Widget build(BuildContext context) {
    final missedData = miss.result ?? [];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.primaryFixed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MISSED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.3),
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      miss.title ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (missedData.isNotEmpty) ...[
            const SizedBox(height: 20),

            // Number tags — pill style with varying opacity
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(missedData.length, (idx) {
                // Fade out towards the end for depth effect
                final opacity = 1.0 - (idx / missedData.length) * 0.5;
                return _PillTag(number: '${missedData[idx]}', opacity: opacity);
              }),
            ),

            const SizedBox(height: 16),
          ] else ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: Colors.greenAccent.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.noMissNumber.tr(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.greenAccent.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PillTag extends StatelessWidget {
  final String number;
  final double opacity;
  const _PillTag({required this.number, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
