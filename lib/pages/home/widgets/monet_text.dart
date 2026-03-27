// ── monet_text.dart ───────────────────────────────────────────────────────────
// FIXED: Removed Expanded from build() return value.
// Expanded must only be used directly inside Row/Column/Flex.
// The parent (Monet) wraps each MoNetText with Expanded instead.

import 'package:flutter/material.dart';
import 'package:new_lion/utils/app_colors.dart';

class MoNetText extends StatelessWidget {
  final String value;
  final bool isHeader;
  final bool? isTime;

  const MoNetText({
    super.key,
    this.isTime,
    required this.value,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    // No Expanded here — parent handles sizing
    if (isHeader || isTime == true) {
      return Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: isHeader ? 18 : 18,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w400,
          letterSpacing: isHeader ? 0.5 : 0,
          height: 1,
        ),
      );
    }

    return Center(
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.gold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}