import 'package:flutter/material.dart';
import '../../../data/models/three_d_model.dart';
import '../../../utils/extension.dart';
import '../../../utils/app_colors.dart';

class ThreedCard extends StatelessWidget {
  final ThreeDModel threeD;

  const ThreedCard({super.key, required this.threeD});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.grey.shade100,
        ),
        
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // ── Date + label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white38 : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    threeD.date ?? 'N/A',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // ── Number badge
            Center(
              child: Text(
                threeD.num ?? '---',
                style: TextStyle(
                  color:  Colors.orange ,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
