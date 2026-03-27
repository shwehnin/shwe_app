import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'utils/app_notification/fcm.dart';
import 'config/localization/app_lang.dart';
import 'config/localization/localization.dart';
import 'config/routes/app_router.dart';
import 'provider/provider_widget.dart';
import 'utils/fonts.dart';
import 'utils/app_colors.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await FCM.initialize();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await WakelockPlus.enable();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      EasyLocalization(
        path: AppLang.localePath,
        fallbackLocale: AppLang.en,
        startLocale: AppLang.en,
        supportedLocales: AppLang.supportedLocale,
        child: MyApp(savedTheme: savedThemeMode),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedTheme;
  const MyApp({super.key, this.savedTheme});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      child: AdaptiveTheme(
        light: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.red,
            selectionColor: Colors.grey,
            selectionHandleColor: Colors.black,
          ),
          fontFamily: Fonts.en,
          useMaterial3: true,
          brightness: Brightness.light,
          primaryColor: AppColors.primary,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary, // navy — buttons, icons, accents
            secondary: Colors.orange,
            surface: Colors.white, // cards
            surfaceContainerHighest:
                AppColors.lightTint, // subtle tint surfaces
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.lightBg,
            foregroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: Fonts.en,
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          scaffoldBackgroundColor: AppColors.lightBg,
        ),

        dark: ThemeData(
          fontFamily: Fonts.en,
          useMaterial3: true,
          brightness: Brightness.dark,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.red,
            selectionColor: Colors.grey,
            selectionHandleColor: Colors.black,
          ),
          primaryColor: AppColors.darkSurface, // ← bright blue accent for dark
          scaffoldBackgroundColor: AppColors.darkBg,
          colorScheme: const ColorScheme.dark(
            primary:
                AppColors.darkSurface, // ← bright accent — visible on dark bg
            secondary: Colors.amber,
            surface: AppColors.darkSurface, // cards
            surfaceContainerHighest: AppColors.darkCard2,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.darkSurface,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: Fonts.en,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        initial: savedTheme ?? AdaptiveThemeMode.light,
        builder: (light, dark) => MaterialApp.router(
          title: '2D MM Lucky7',
          theme: light,
          darkTheme: dark,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.config,
          builder: FToastBuilder(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
