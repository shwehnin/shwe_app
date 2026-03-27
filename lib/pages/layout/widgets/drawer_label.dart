import 'package:flutter/material.dart';
import 'package:new_lion/utils/app_colors.dart';

class DrawerLabel extends StatelessWidget {
  const DrawerLabel({super.key, required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(0, 4, 12, 6),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? AppColors.white : AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: .4,
        ),
      ),
    );
  }
}
