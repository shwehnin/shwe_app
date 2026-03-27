import 'package:flutter/material.dart';
import 'package:new_lion/data/models/nav_item.dart';
import 'package:new_lion/utils/app_colors.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  final int selectedIndex;
  final List<NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkBg : AppColors.cardBg,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Row(
          children: List.generate(items.length, (i) {
            final selected = i == selectedIndex;
            final item = items[i];
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 54,
                  child: Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: selected
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: .5),
                      ),
                      child: Center(
                        child: selected
                            ? Image.asset(
                                item.icon,
                                width: 26,
                                height: 26,
                                color: AppColors.lightText,
                              )
                            : Image.asset(
                                item.activeIcon,
                                width: 26,
                                height: 26,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
