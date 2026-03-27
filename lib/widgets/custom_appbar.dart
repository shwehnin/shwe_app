import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_lion/admob/ad_helper.dart';
import 'package:new_lion/config/routes/route_locations.dart';
import 'package:new_lion/pages/home/widgets/chat_icon.dart';
import 'package:new_lion/utils/app_colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.showChatIcon = true,
    this.showMenuIcon = true,
    this.extraActions,
  });

  final String title;
  final bool showChatIcon;
  final bool showMenuIcon;
  final List<Widget>? extraActions;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: isDarkMode ? AppColors.darkBg : AppColors.lightBg,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.secondary.withValues(alpha: .25),
        ),
      ),
      leadingWidth: showMenuIcon ? 170 : null,
      leading: showMenuIcon
          ? Builder(
              builder: (context) => Row(
                children: [
                  IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: Icon(Icons.menu_rounded),
                    padding: EdgeInsets.zero,
                    color: AppColors.lightText,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightText,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            )
          : null,
      actions: [
        if (extraActions != null) ...extraActions!,
        if (showChatIcon)
          GestureDetector(
            onTap: () {
              AdHelper.showInterstitialAd(
                onComplete: () => context.pushNamed(RouteLocation.publicChat),
              );
            },
            child: ChatIcon(),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
