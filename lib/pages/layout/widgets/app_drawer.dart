import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_lion/config/localization/localization.dart';
import 'package:new_lion/config/routes/route_locations.dart';
import 'package:new_lion/pages/layout/widgets/app_drawer_header.dart';
import 'package:new_lion/pages/layout/widgets/drawer_btn.dart';
import 'package:new_lion/pages/layout/widgets/drawer_label.dart';
import 'package:new_lion/pages/layout/widgets/drawer_tile.dart';
import 'package:new_lion/pages/profile/logout_sheet.dart';
import 'package:new_lion/utils/const.dart';
import 'package:new_lion/utils/extension.dart';
import 'package:new_lion/utils/global.dart';
import 'package:new_lion/utils/reusable.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            if (Global.user != null) AppDrawerHeader(),
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                children: [
                  // Profile Section
                  if (Global.user != null)
                    DrawerLabel(label: "User Information", isDark: isDark),
                  if (Global.user != null)
                    DrawerTile(
                      icon: Icons.person_2_sharp,
                      title: "Edit Profile",
                      onTap: () {
                        Navigator.pop(context);
                        if (Global.user == null) {
                          context.pushNamed(RouteLocation.login);
                        } else {
                          context.pushNamed(RouteLocation.updateProfile);
                        }
                      },
                    ),
                  if (Global.user != null)
                    DrawerTile(
                      icon: Icons.block,
                      title: "Block List",
                      onTap: () {
                        if (Global.user == null) {
                          context.pushNamed(RouteLocation.login);
                        } else {
                          context.pushNamed(RouteLocation.blockList);
                        }
                      },
                    ),
                  if (Global.user != null) ...[
                    if (Global.user != null) SizedBox(height: 8),
                    Divider(
                      color: context.colors.secondary.withValues(alpha: .15),
                      height: 1,
                    ),
                    SizedBox(height: 8),
                  ],

                  DrawerLabel(label: "Calendar", isDark: isDark),
                  DrawerTile(
                    icon: Icons.calendar_month_outlined,
                    title: LocaleKeys.setHoliday.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(RouteLocation.setHolidays);
                    },
                  ),
                  SizedBox(height: 8),
                  Divider(
                    color: context.colors.onSurface.withValues(alpha: .15),
                    height: 1,
                  ),
                  SizedBox(height: 8),
                  // Others section
                  DrawerLabel(label: "Others", isDark: isDark),
                  DrawerTile(
                    icon: Icons.local_attraction,
                    title: LocaleKeys.thaiLotto.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(RouteLocation.lottoThai);
                    },
                  ),

                  DrawerTile(
                    icon: Icons.bar_chart_outlined,
                    title: LocaleKeys.missNumber.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(RouteLocation.analysis);
                    },
                  ),
                  DrawerTile(
                    icon: Icons.settings,
                    title: LocaleKeys.setting.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(RouteLocation.setting);
                    },
                  ),
                  DrawerTile(
                    icon: Icons.policy,
                    title: LocaleKeys.privacyPolicy.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(RouteLocation.privacyPolicy);
                    },
                  ),
                ],
              ),
            ),

            // Bottom buttons
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Row(
                children: [
                  // ── Logout ──
                  if (Global.user != null)
                    Expanded(
                      child: DrawerBtn(
                        label: LocaleKeys.logout.tr(),
                        icon: Icons.logout_rounded,
                        isDark: isDark,
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => LogoutSheet(),
                          );
                        },
                      ),
                    ),
                  // if (Global.user != null)
                  SizedBox(width: 10),
                  // Rate Our App button
                  Expanded(
                    child: DrawerBtn(
                      label: LocaleKeys.rating.tr(),
                      icon: Icons.star,
                      isDark: isDark,
                      onTap: () async {
                        Navigator.pop(context);
                        var packageInfo = await PackageInfo.fromPlatform();
                        var url =
                            "${Const.playstoreURL}?id=${packageInfo.packageName}&hl=en";
                        Reusable.openURL(url);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
