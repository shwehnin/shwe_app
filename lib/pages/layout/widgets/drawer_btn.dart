import 'package:flutter/material.dart';
import 'package:new_lion/utils/app_colors.dart';

class DrawerBtn extends StatelessWidget {
  const DrawerBtn({
    super.key,
    required this.label,
    this.icon,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: AppColors.secondary),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.cardBg,
        foregroundColor: AppColors.white,
        minimumSize: Size.fromHeight(50),
        padding: EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
