import 'package:flutter/material.dart';
import 'package:new_lion/utils/app_colors.dart';
import 'package:new_lion/utils/global.dart';

class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 28),
      decoration: BoxDecoration(
        // color: AppColors.cardBg,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.purple.withValues(alpha: .4),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 34,
              child: Text(
                (Global.user?.name?.isNotEmpty == true)
                    ? Global.user!.name![0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            Global.user?.name ?? "User",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2),
          Text(
            Global.user?.email ?? 'abc@gmail.com',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
