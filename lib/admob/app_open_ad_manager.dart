import 'dart:async';
import '../utils/global.dart';

import 'ad_units.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  StreamController<bool> canGoNext = StreamController<bool>();

  /// Singleton instance.
  static final AppOpenAdManager _instance = AppOpenAdManager._internal();

  factory AppOpenAdManager() {
    return _instance;
  }

  AppOpenAdManager._internal();

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  String adUnitId = AdUnits.appOpen!;

  /// Load an [AppOpenAd].
  Future<void> loadAd() async {
    if (Global.offAds) return;

    await AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          if (!canGoNext.isClosed) canGoNext.add(true);
          debugPrint("Open Ads loaded successfully");
        },
        onAdFailedToLoad: (error) {
          if (!canGoNext.isClosed) canGoNext.add(true);
          debugPrint('AppOpenAd failed to load: $error');
          // Retry loading the ad after a delay (e.g., 10 seconds).
          Future.delayed(const Duration(seconds: 10), () {
            loadAd();
          });
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _appOpenAd != null;

  /// Shows the ad, if one exists and is not already being shown.
  ///
  /// If the previously cached ad has expired, this just loads and caches a
  /// new ad.
  void showAdIfAvailable({Function? next}) {
    if (Global.offAds) {
      if (next != null) next();
      return;
    }

    if (!isAdAvailable) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      if (next != null) next();
      return;
    }
    if (_isShowingAd) {
      debugPrint(
        'Tried to show ad while already showing an ad.',
      );
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      debugPrint(
        'Maximum cache duration exceeded. Loading another ad.',
      );
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd(); // Attempt to load a new ad after failure.
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd(); // Load a new ad for the next session.
        if (next != null) next();
      },
    );
    _appOpenAd!.show();
  }
}
