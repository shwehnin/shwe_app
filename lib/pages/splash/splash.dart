import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../admob/ad_helper.dart';
import '../../admob/app_lifecycle_reactor.dart';
import '../../admob/app_open_ad_manager.dart';
import '../../utils/update_manger.dart';
import '../../widgets/blinker.dart';
import '../../config/routes/route_locations.dart';
import '../../data/api/config_api.dart';
import '../../provider/live_provider.dart';
import '../../utils/global.dart';
import '../../utils/images.dart';
import '../../widgets/loading_view.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late LiveProvider _provider;
  late AppLifecycle _appLifeCycle;
  final _openAdManager = AppOpenAdManager();

  @override
  void initState() {
    _provider = Provider.of<LiveProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appLifeCycle = AppLifecycle(openAdManager: _openAdManager);
      BlinkController.instance.start(
        visibleDuration: Duration(seconds: 3),
        hiddenDuration: Duration(milliseconds: 500),
      );
      _appLifeCycle.listenToAppStateChanges();
      AdHelper.precacheInterstitialAd();
      AdHelper.precacheRewardedAd();
      _openAdManager.loadAd();
     _next();
    });
    super.initState();
  }

  _next() async {
    try {
      await UpdateManager.checkAndUpdate();
      await ConfigApi.get();
      _provider.update(Global.config.latestData!);
      if (mounted) context.go(RouteLocation.layout);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _openAdManager.canGoNext.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Icon
            Image.asset(
              Imgs.splash,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            LoadingView(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
